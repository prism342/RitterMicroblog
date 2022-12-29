import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ritter_microblog/data_models.dart';
import 'package:tuple/tuple.dart';

final userDataCol = FirebaseFirestore.instance.collection('userProfile');
final postCol = FirebaseFirestore.instance.collection('post');
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

String getSelfUid() {
  return FirebaseAuth.instance.currentUser?.uid ?? "";
}

Future<void> createPost(String postContent, List<String> localImages) async {
  // create post doc
  final doc = postCol.doc();

  // upload images
  List<String> postImageURLs = [];
  for (int i = 0; i < localImages.length; i++) {
    postImageURLs.add(await uploadImage(
        localImages[i], "user/${getSelfUid()}/posts/${doc.id}/$i"));
  }

  // create post object
  final post = PostActivity(
      creatorID: getSelfUid(),
      timestamp: Timestamp.now(),
      postContent: postContent,
      postImageURLs: postImageURLs);

  await doc.set(post.toMap());
}

Future<PostActivity?> getPostByID(String docID) async {
  final snap = await postCol.doc(docID).get();
  return PostActivity.fromMap(docID, snap.data());
}

Future<UserData> getUserDataByID(String docID) async {
  final snap = await userDataCol.doc(docID).get();
  return UserData.fromData(docID, snap.data());
}

// Future<List<Tuple2<PostActivity, UserData>>> getLatestFeed() async {
//   final List<Tuple2<PostActivity, UserData>> feeds = [];

//   final querySnap =
//       await postCol.where("creatorID", isEqualTo: getSelfUid()).get();

//   final docSnaps = querySnap.docs;

//   for (final docSnap in docSnaps) {
//     final post = PostActivity.fromMap(docSnap.id, docSnap.data());
//     if (post == null) continue;
//     final creator = await getUserDataByID(post.creatorID);
//     feeds.add(Tuple2(post, creator));
//   }

//   return feeds;
// }

Stream<List<PostActivity?>> getLatestFeedStream() {
  final querySnapStream =
      postCol.where("creatorID", isEqualTo: getSelfUid()).snapshots();

  final docsStream = querySnapStream.map((querySnap) => querySnap.docs
      .map((docSnap) => PostActivity.fromMap(docSnap.id, docSnap.data()))
      .toList());

  return docsStream;
}

Future<void> createPostActivity(
    String postContent, List<String> localImagePaths) async {
  final post = PostActivity(
      creatorID: getSelfUid(),
      timestamp: Timestamp.now(),
      postContent: postContent,
      postImageURLs: []);

  await postCol.add(post.toMap());
}

Future<void> createComment(String refPostID, String comment) async {
  final commentActivity = CommentActivity(
      creatorID: getSelfUid(),
      timestamp: Timestamp.now(),
      refPostID: refPostID,
      comment: comment);

  await commentCol.add(commentActivity.toMap());
}

Future<void> createRepost(String refPostID) async {
  final repostActivity = RepostActivity(
      creatorID: getSelfUid(),
      timestamp: Timestamp.now(),
      refPostID: refPostID);

  await repostCol.add(repostActivity.toMap());
}

// Future<void> createLike(String refPostID) async {
//   if (await isPostLiked(refPostID)) {
//     return;
//   } else {
//     final likeActivity = LikeActivity(
//         creatorID: getSelfUid(),
//         timestamp: Timestamp.now(),
//         refPostID: refPostID);

//     await likeCol.add(likeActivity.toMap());
//   }
// }

// Future<void> removeLike(String postID) async {
//   final likeQuerySnap = await likeCol
//       .where("refPostID", isEqualTo: postID)
//       .where("creatorID", isEqualTo: getSelfUid())
//       .limit(1)
//       .get();
//   if (likeQuerySnap.docs.isNotEmpty) {
//     await likeCol.doc(likeQuerySnap.docs.first.id).delete();
//   }
// }

// Future<bool> isPostLiked(String postID) async {
//   final likeQuerySnap = await likeCol
//       .where("refPostID", isEqualTo: postID)
//       .where("creatorID", isEqualTo: getSelfUid())
//       .limit(1)
//       .get();
//   final isLiked = likeQuerySnap.docs.isNotEmpty;
//   return isLiked;
// }

Stream<bool> isPostlikedStream(String postID) {
  final likeQuerySnapStream = likeCol
      .where("refPostID", isEqualTo: postID)
      .where("creatorID", isEqualTo: getSelfUid())
      .limit(1)
      .snapshots();
  final likeStream =
      likeQuerySnapStream.map((querySnap) => querySnap.docs.isNotEmpty);
  return likeStream;
}

Future<void> togglePostLike(String postID) async {
  final likeQuerySnap = await likeCol
      .where("refPostID", isEqualTo: postID)
      .where("creatorID", isEqualTo: getSelfUid())
      .get();
  if (likeQuerySnap.docs.isNotEmpty) {
    for (var docSnap in likeQuerySnap.docs) {
      likeCol.doc(docSnap.id).delete();
    }
  } else {
    final likeActivity = LikeActivity(
      creatorID: getSelfUid(),
      timestamp: Timestamp.now(),
      refPostID: postID,
    );

    await likeCol.add(likeActivity.toMap());
  }
}

Stream<bool> isPostRepostedStream(String postID) {
  final repostQuerySnapStream = repostCol
      .where("refPostID", isEqualTo: postID)
      .where("creatorID", isEqualTo: getSelfUid())
      .limit(1)
      .snapshots();
  final repostStream =
      repostQuerySnapStream.map((querySnap) => querySnap.docs.isNotEmpty);
  return repostStream;
}

Future<void> togglePostRepost(String postID) async {
  final repostQuerySnap = await repostCol
      .where("refPostID", isEqualTo: postID)
      .where("creatorID", isEqualTo: getSelfUid())
      .get();
  if (repostQuerySnap.docs.isNotEmpty) {
    for (var docSnap in repostQuerySnap.docs) {
      repostCol.doc(docSnap.id).delete();
    }
  } else {
    final repostActivity = RepostActivity(
      creatorID: getSelfUid(),
      timestamp: Timestamp.now(),
      refPostID: postID,
    );

    await repostCol.add(repostActivity.toMap());
  }
}

Stream<bool> isPostCommentedStream(String postID) {
  final commentQuerySnapStream = commentCol
      .where("refPostID", isEqualTo: postID)
      .where("creatorID", isEqualTo: getSelfUid())
      .limit(1)
      .snapshots();
  final isCommentedStream =
      commentQuerySnapStream.map((querySnap) => querySnap.docs.isNotEmpty);
  return isCommentedStream;
}

Stream<List<CommentActivity?>> getPostCommentsStream(String postID) {
  final commentQuerySnapStream =
      commentCol.where("refPostID", isEqualTo: postID).snapshots();
  final commentsStream = commentQuerySnapStream.map(
    (querySnap) => querySnap.docs
        .map((docSnap) => CommentActivity.fromMap(docSnap.id, docSnap.data()))
        .toList(),
  );
  return commentsStream;
}

Stream<int> getNumberOfLikesStream(String postID) {
  final queryStream = likeCol.where("refPostID", isEqualTo: postID).snapshots();
  final likesStream = queryStream.map((querySnap) => querySnap.docs.length);
  return likesStream;
}

Stream<int> getNumberOfCommentsStream(String postID) {
  final queryStream =
      commentCol.where("refPostID", isEqualTo: postID).snapshots();
  final likesStream = queryStream.map((querySnap) => querySnap.docs.length);
  return likesStream;
}

Stream<int> getNumberOfRepostsStream(String postID) {
  final queryStream =
      repostCol.where("refPostID", isEqualTo: postID).snapshots();
  final likesStream = queryStream.map((querySnap) => querySnap.docs.length);
  return likesStream;
}
