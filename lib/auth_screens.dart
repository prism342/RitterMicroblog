import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'dart:io';

SignInScreen buildSignInScreen(BuildContext context) {
  // Future<void> showEmailVerificationDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Verify your email!'),
  //         content: const Text(
  //             'A verification email has been sent to your email address.'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Resend'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               FirebaseAuth.instance.currentUser!.sendEmailVerification();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('Verified'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               var _timer =
  //                   Timer.periodic(const Duration(seconds: 3), (timer) {
  //                 print("reload current user");

  //                 FirebaseAuth.instance.currentUser!.reload();

  //                 if (FirebaseAuth.instance.currentUser!.emailVerified) {
  //                   Navigator.pushNamedAndRemoveUntil(
  //                       context, '/home', (route) => false);
  //                 }
  //               });
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  List<FirebaseUIAction> actions = [
    ForgotPasswordAction((context, email) {
      Navigator.pushNamed(
        context,
        '/forgot-password',
        arguments: {'email': email},
      );
    }),
    AuthStateChangeAction<SignedIn>((context, state) {
      if (!state.user!.emailVerified) {
        print("email not verified.");
        // showEmailVerificationDialog();
        Navigator.pushReplacementNamed(context, '/verify-email');
      } else {
        print("email verified!");
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    }),
    AuthStateChangeAction<UserCreated>((context, state) {
      if (!state.credential.user!.emailVerified) {
        // FirebaseAuth.instance.currentUser!.sendEmailVerification();
        // showEmailVerificationDialog();
        Navigator.pushReplacementNamed(context, '/verify-email');
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    }),
  ];

  return SignInScreen(
    providers: [
      EmailAuthProvider(),
    ],
    actions: actions,
    styles: const {
      EmailFormStyle(signInButtonVariant: ButtonVariant.filled),
    },
    // headerBuilder: (_, _1, _2) => Image.file(File('assets/images/logo.jpg')),
    // sideBuilder: (_,_1)=>Image.file(File('assets/images/logo.jpg')),
    subtitleBuilder: (context, action) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          action == AuthAction.signIn
              ? 'Welcome to Firebase UI! Please sign in to continue.'
              : 'Welcome to Firebase UI! Please create an account to continue',
        ),
      );
    },
    footerBuilder: (context, action) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            action == AuthAction.signIn
                ? 'By signing in, you agree to our terms and conditions.'
                : 'By registering, you agree to our terms and conditions.',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    },
  );
}

ForgotPasswordScreen buildForgotPasswordScreen(BuildContext context) {
  final arguments =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

  return ForgotPasswordScreen(
    email: arguments?['email'],
    headerMaxExtent: 200,
    // headerBuilder: headerIcon(Icons.lock),
    // sideBuilder: sideIcon(Icons.lock),
  );
}

EmailVerificationScreen buildEmailVerificationScreen(BuildContext context) {
  var _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
    print("reload current user");

    FirebaseAuth.instance.currentUser!.reload();

    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      timer.cancel();
    }
  });

  return EmailVerificationScreen(
    // headerBuilder: headerIcon(Icons.verified),
    // sideBuilder: sideIcon(Icons.verified),
    // actionCodeSettings: actionCodeSettings,
    actions: [
      // EmailVerifiedAction(() {
      //   Navigator.pushReplacementNamed(context, '/home');
      // }),
      AuthCancelledAction((context) {
        _timer.cancel();
        FirebaseUIAuth.signOut(context: context);
        Navigator.pushReplacementNamed(context, '/signin');
      }),
    ],
  );
}
