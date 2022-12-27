import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ritter_microblog/data_models.dart';

final userProfileCol = FirebaseFirestore.instance.collection('userProfile');
final postsCol = FirebaseFirestore.instance.collection('posts');

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
  var selfUserDataSnapshotStream = userProfileCol.doc(uid).snapshots();

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

  await userProfileCol.doc(uid).update(userData.toData());
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
