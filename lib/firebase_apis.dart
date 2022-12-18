import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ritter_microblog/data_models.dart';

final userProfileCol = FirebaseFirestore.instance.collection('userProfile');

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

Future<void> uploadImage(String cloudPath) async {
  final storageRef = FirebaseStorage.instance.ref();
  final imageRef = storageRef.child(cloudPath);
}

Future<void> uploadProfilePic(String cloudPath) async {}

Stream<UserData> getUserProfileDataStream(String uid) {
  var selfUserDataSnapshotStream = userProfileCol.doc(uid).snapshots();

  var selfUserDataStream = selfUserDataSnapshotStream
      .map((snapshot) => UserData.fromData(snapshot.id, snapshot.data()));

  return selfUserDataStream;
}

Stream<UserData> getSelfProfileDataStream() {
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
