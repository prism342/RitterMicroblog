import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

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
