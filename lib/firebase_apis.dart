import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ritter_microblog/data_models.dart';
import 'package:tuple/tuple.dart';

final userDataCol = FirebaseFirestore.instance.collection('userData');
final postsCol = FirebaseFirestore.instance.collection('posts');
final commentsCol = FirebaseFirestore.instance.collection('comments');
final repostsCol = FirebaseFirestore.instance.collection('reposts');
final likesCol = FirebaseFirestore.instance.collection('likes');
final followingsCol = FirebaseFirestore.instance.collection('followings');

/*
Authentication functions
 */

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

bool isEmailVerified() {
  return FirebaseAuth.instance.currentUser?.emailVerified ?? false;
}

String? getSelfEmail() {
  return FirebaseAuth.instance.currentUser?.email;
}

String getSelfUid() {
  return FirebaseAuth.instance.currentUser?.uid ?? "";
}

/*
  upload a local image to a cloud path on firebase storeage
 */

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
  updateSelfUserData(UserData(profilePicUrl: imageUrl));
}

Stream<UserData> getUserUserDataStream(String uid) {
  var selfUserDataSnapshotStream = userDataCol.doc(uid).snapshots();

  var selfUserDataStream = selfUserDataSnapshotStream
      .map((snapshot) => UserData.fromMap(snapshot.id, snapshot.data()));

  return selfUserDataStream;
}

Stream<UserData> getSelfUserDataStream() {
  String selfUserID = FirebaseAuth.instance.currentUser?.uid ?? "";

  return getUserUserDataStream(selfUserID);
}

Future<void> createSelfUserData(UserData userData) async {
  String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

  await userDataCol.doc(uid).set(userData.toData());
}

Future<void> updateSelfUserData(UserData userData) async {
  String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

  await userDataCol.doc(uid).update(userData.toData());
}

Future<UserData> getUserDataByID(String docID) async {
  final snap = await userDataCol.doc(docID).get();
  return UserData.fromMap(docID, snap.data());
}

/*
create activities
*/

Future<void> createPost(String postContent, List<String> localImages) async {
  // create post doc
  final doc = postsCol.doc();

  // upload images
  List<String> postImageURLs = [];
  for (int i = 0; i < localImages.length; i++) {
    postImageURLs.add(await uploadImage(
        localImages[i], "user/${getSelfUid()}/posts/${doc.id}/$i"));
  }

  final post = PostActivity(
      creatorID: getSelfUid(),
      timestamp: Timestamp.now(),
      postContent: postContent,
      postImageURLs: postImageURLs);

  await doc.set(post.toMap());
}

Future<void> createPostActivity(
    String postContent, List<String> localImagePaths) async {
  final post = PostActivity(
      creatorID: getSelfUid(),
      timestamp: Timestamp.now(),
      postContent: postContent,
      postImageURLs: []);

  await postsCol.add(post.toMap());
}

Future<void> createComment(String refPostID, String comment) async {
  final commentActivity = CommentActivity(
      creatorID: getSelfUid(),
      timestamp: Timestamp.now(),
      refPostID: refPostID,
      comment: comment);

  await commentsCol.add(commentActivity.toMap());
}

Future<void> createRepost(String refPostID) async {
  final repostActivity = RepostActivity(
      creatorID: getSelfUid(),
      timestamp: Timestamp.now(),
      refPostID: refPostID);

  await repostsCol.add(repostActivity.toMap());
}

Future<void> togglePostLike(String postID) async {
  final likeQuerySnap = await likesCol
      .where("refPostID", isEqualTo: postID)
      .where("creatorID", isEqualTo: getSelfUid())
      .get();
  if (likeQuerySnap.docs.isNotEmpty) {
    for (var docSnap in likeQuerySnap.docs) {
      likesCol.doc(docSnap.id).delete();
    }
  } else {
    final likeActivity = LikeActivity(
      creatorID: getSelfUid(),
      timestamp: Timestamp.now(),
      refPostID: postID,
    );

    await likesCol.add(likeActivity.toMap());
  }
}

Future<void> togglePostRepost(String postID) async {
  final repostQuerySnap = await repostsCol
      .where("refPostID", isEqualTo: postID)
      .where("creatorID", isEqualTo: getSelfUid())
      .get();
  if (repostQuerySnap.docs.isNotEmpty) {
    for (var docSnap in repostQuerySnap.docs) {
      repostsCol.doc(docSnap.id).delete();
    }
  } else {
    final repostActivity = RepostActivity(
      creatorID: getSelfUid(),
      timestamp: Timestamp.now(),
      refPostID: postID,
    );

    await repostsCol.add(repostActivity.toMap());
  }
}

/*
get activities
 */

Stream<bool> isPostlikedStream(String postID) {
  final likeQuerySnapStream = likesCol
      .where("refPostID", isEqualTo: postID)
      .where("creatorID", isEqualTo: getSelfUid())
      .limit(1)
      .snapshots();
  final likeStream =
      likeQuerySnapStream.map((querySnap) => querySnap.docs.isNotEmpty);
  return likeStream;
}

Stream<bool> isPostRepostedStream(String postID) {
  final repostQuerySnapStream = repostsCol
      .where("refPostID", isEqualTo: postID)
      .where("creatorID", isEqualTo: getSelfUid())
      .limit(1)
      .snapshots();
  final repostStream =
      repostQuerySnapStream.map((querySnap) => querySnap.docs.isNotEmpty);
  return repostStream;
}

Stream<bool> isPostCommentedStream(String postID) {
  final commentQuerySnapStream = commentsCol
      .where("refPostID", isEqualTo: postID)
      .where("creatorID", isEqualTo: getSelfUid())
      .limit(1)
      .snapshots();
  final isCommentedStream =
      commentQuerySnapStream.map((querySnap) => querySnap.docs.isNotEmpty);
  return isCommentedStream;
}

Stream<int> getNumberOfLikesStream(String postID) {
  final queryStream =
      likesCol.where("refPostID", isEqualTo: postID).snapshots();
  final likesStream = queryStream.map((querySnap) => querySnap.docs.length);
  return likesStream;
}

Stream<int> getNumberOfCommentsStream(String postID) {
  final queryStream =
      commentsCol.where("refPostID", isEqualTo: postID).snapshots();
  final likesStream = queryStream.map((querySnap) => querySnap.docs.length);
  return likesStream;
}

Stream<int> getNumberOfRepostsStream(String postID) {
  final queryStream =
      repostsCol.where("refPostID", isEqualTo: postID).snapshots();
  final likesStream = queryStream.map((querySnap) => querySnap.docs.length);
  return likesStream;
}

Future<PostActivity?> getPostByID(String docID) async {
  final snap = await postsCol.doc(docID).get();
  return PostActivity.fromMap(docID, snap.data());
}

Stream<List<PostActivity?>> getLatestFeedStream() {
  final querySnapStream = postsCol.snapshots();

  final docsStream = querySnapStream.map((querySnap) => querySnap.docs
      .map((docSnap) => PostActivity.fromMap(docSnap.id, docSnap.data()))
      .toList());

  return docsStream;
}

Stream<List<CommentActivity?>> getPostCommentsStream(String postID) {
  final commentQuerySnapStream =
      commentsCol.where("refPostID", isEqualTo: postID).snapshots();
  final commentsStream = commentQuerySnapStream.map(
    (querySnap) => querySnap.docs
        .map((docSnap) => CommentActivity.fromMap(docSnap.id, docSnap.data()))
        .toList(),
  );
  return commentsStream;
}

Future<List<CommentActivity>> getCommentActivities(String userID) async {
  final querySnap =
      await commentsCol.where("creatorID", isEqualTo: userID).get();
  final commentActivities = querySnap.docs
      .map((docSnap) => CommentActivity.fromMap(docSnap.id, docSnap.data()))
      .whereType<CommentActivity>()
      .toList();
  return commentActivities;
}

Future<List<RepostActivity>> getRepostActivities(String userID) async {
  final querySnap =
      await repostsCol.where("creatorID", isEqualTo: userID).get();
  final repostActivities = querySnap.docs
      .map((docSnap) => RepostActivity.fromMap(docSnap.id, docSnap.data()))
      .whereType<RepostActivity>()
      .toList();
  return repostActivities;
}

Future<List<LikeActivity>> getLikeActivities(String userID) async {
  final querySnap = await likesCol.where("creatorID", isEqualTo: userID).get();
  final likeActivities = querySnap.docs
      .map((docSnap) => LikeActivity.fromMap(docSnap.id, docSnap.data()))
      .whereType<LikeActivity>()
      .toList();
  return likeActivities;
}

/*
search
*/

Future<List<PostActivity?>> searchPosts(String keyWords) async {
  final query = await postsCol
      .where("postContent", isGreaterThanOrEqualTo: keyWords)
      .where("postContent", isLessThanOrEqualTo: '$keyWords\uf8ff')
      .get();
  final result = query.docs
      .map((docSnap) => PostActivity.fromMap(docSnap.id, docSnap.data()))
      .toList();
  return result;
}

Future<List<UserData?>> searchUsers(String keyWords) async {
  final query = await userDataCol
      .where("username", isGreaterThanOrEqualTo: keyWords)
      .where("username", isLessThanOrEqualTo: '$keyWords\uf8ff')
      .get();
  final result = query.docs
      .map((docSnap) => UserData.fromMap(docSnap.id, docSnap.data()))
      .toList();
  return result;
}
