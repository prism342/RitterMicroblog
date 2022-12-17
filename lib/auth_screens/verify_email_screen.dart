import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ritter_microblog/firebase_apis.dart';
import 'package:ritter_microblog/widgets/my_buttons.dart';
import 'package:ritter_microblog/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyVerifyEmailScreen extends StatefulWidget {
  const MyVerifyEmailScreen({super.key});

  @override
  State<MyVerifyEmailScreen> createState() => _MyVerifyEmailScreenState();
}

class _MyVerifyEmailScreenState extends State<MyVerifyEmailScreen> {
  @override
  Widget build(BuildContext context) {
    final Future<String?> email = SharedPreferences.getInstance()
        .then((prefs) => prefs.getString("email"));

    void onResendEmailButtonPressed() async {
      try {
        await sendVerificationEmail();
        showInfoToast("Send email sucess!");
      } catch (e) {
        showInfoToast("Send email failed!");
      }
    }

    void onVerifiedButtonPressed() {
      log(FirebaseAuth.instance.currentUser!.toString(),
          name: "email verified");
      return;
      if (isEmailVerified() ?? false) {
        Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
      } else {
        showInfoToast("Can't verify your email.");
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("A verification email has sent to:"),
                  FutureBuilder<String?>(
                      future: email,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data ?? "");
                        } else {
                          return const Text("");
                        }
                      }),
                ],
              ),
            ),
            Flexible(
              child: Column(children: [
                MyAuthButton(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    lable: "Verified",
                    onPressed: onVerifiedButtonPressed),
                MyTextWithButton(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    text: "Didn't receive email?",
                    buttonText: "Resend",
                    onPressed: onResendEmailButtonPressed)
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
