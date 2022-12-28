import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ritter_microblog/data_models.dart';
import 'package:tuple/tuple.dart';

final userDataCol = FirebaseFirestore.instance.collection('userProfile');
final postsCol = FirebaseFirestore.instance.collection('posts');
final commentCol = FirebaseFirestore.instance.collection('comment');
final repostCol = FirebaseFirestore.instance.collection('repost');
final likeCol = FirebaseFirestore.instance.collection('like');
final followCol = FirebaseFirestore.instance.collection('follow');

Future<void> signup(String email, String password) async {
  // final credential =
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
}

Future<void> signin(String email, String password) async {
  // final credential =
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: password);
}

Future<void> signout() async {
  await FirebaseAuth.instance.signOut();
}

Future<void> sendVerificationEmail() async {
  await FirebaseAuth.instance.currentUser?.sendEmailVerification();
}

bool? isEmailVerified() {
  return FirebaseAuth.instance.currentUser?.emailVerified;
}

Future<String> uploadImage(String localPath, String cloudPath) async {
  final storageRef = FirebaseStorage.instance.ref();
  final imageRef = storageRef.child(cloudPath);

  File file = File(localPath);

  await imageRef.putFile(file);

  return imageRef.getDownloadURL();
}

Future<void> uploadProfilePic(String localPath) async {
  final imageUrl =
      await uploadImage(localPath, "user/${getSelfUid()}/profile-pic");
  updateSelfProfileData(UserData(profilePicUrl: imageUrl));
}

// Future<String?> getProfilePicUrl() async {
//   String? url;

//   String uid = getSelfUid() ?? "";

//   try {
//     url = await FirebaseStorage.instance
//         .ref()
//         .child('user/$uid/profile-picture.png')
//         .getDownloadURL();
//   } on FirebaseException catch (e) {
//     log(e.message.toString());
//   }

//   return url;
// }

Stream<UserData> getUserProfileDataStream(String uid) {
  var selfUserDataSnapshotStream = userDataCol.doc(uid).snapshots();

  var selfUserDataStream = selfUserDataSnapshotStream
      .map((snapshot) => UserData.fromData(snapshot.id, snapshot.data()));

  return selfUserDataStream;
}

Stream<UserData> getSelfProfileDataStream() {
  log("get user data stream");

  String selfUserID = FirebaseAuth.instance.currentUser?.uid ?? "";

  return getUserProfileDataStream(selfUserID);
}

Future<void> updateSelfProfileData(UserData userData) async {
  String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

  await userDataCol.doc(uid).update(userData.toData());
}

String? getSelfEmail() {
  return FirebaseAuth.instance.currentUser?.email;
}

String? getSelfUid() {
  return FirebaseAuth.instance.currentUser?.uid;
}

Future<void> createPost(String textContent, List<String> localImages) async {
  // create post doc
  final doc = postsCol.doc();

  // upload images
  List<String> imageURLs = [];
  for (int i = 0; i < localImages.length; i++) {
    imageURLs.add(await uploadImage(
        localImages[i], "user/${getSelfUid()}/posts/${doc.id}/$i"));
  }

  // create post object
  final post = Post(
      creatorID: getSelfUid(),
      timestamp: Timestamp.now(),
      textContent: textContent,
      imageURLs: imageURLs);

  await doc.set(post.toData());
}

Future<Post> getPostByID(String docID) async {
  final snap = await postsCol.doc(docID).get();
  return Post.fromData(docID, snap.data());
}

Future<UserData> getUserDataByID(String docID) async {
  final snap = await userDataCol.doc(docID).get();
  return UserData.fromData(docID, snap.data());
}

// Stream<List<Post>> getFeed() async {
//   final querySnapStream =
//       postsCol.where("creatorID", isEqualTo: getSelfUid()).snapshots();

//   final posts = querySnapStream
//       .map((querySnap) => querySnap.docs.map((docSnap) => docSnap.data()))
//       ;

//   return Stream<List<Post>>;
// }

Future<List<Tuple2<Post, UserData>>> getLatestFeed() async {
  final List<Tuple2<Post, UserData>> feeds = [];

  final querySnap =
      await postsCol.where("creatorID", isEqualTo: getSelfUid()).get();

  final docSnaps = querySnap.docs;

  for (final docSnap in docSnaps) {
    final post = Post.fromData(docSnap.id, docSnap.data());
    final creator = await getUserDataByID(post.creatorID ?? "");
    feeds.add(Tuple2(post, creator));
  }

  return feeds;
}

Future<void> createPostActivity(
    String postContent, List<String> localImagePaths) async {
  final post = PostActivity(
      creatorID: getSelfUid()!,
      timestamp: Timestamp.now(),
      postContent: postContent,
      postImageURLs: []);

  await postsCol.add(post.toMap());
}

Future<void> createComment(String refPostID, String comment) async {
  final commentActivity = CommentActivity(
      creatorID: getSelfUid()!,
      timestamp: Timestamp.now(),
      refPostID: refPostID,
      comment: comment);

  await commentCol.add(commentActivity.toMap());
}

Future<void> createRepost(String refPostID) async {
  final repostActivity = RepostActivity(
      creatorID: getSelfUid()!,
      timestamp: Timestamp.now(),
      refPostID: refPostID);

  await repostCol.add(repostActivity.toMap());
}

Future<void> createLike(String refPostID) async {
  final likeActivity = LikeActivity(
      creatorID: getSelfUid()!,
      timestamp: Timestamp.now(),
      refPostID: refPostID);

  await likeCol.add(likeActivity.toMap());
}
