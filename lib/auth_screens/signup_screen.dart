import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ritter_microblog/data_models.dart';
import 'package:ritter_microblog/firebase_apis.dart';
import 'package:ritter_microblog/widgets/my_text_fields.dart';
import 'package:ritter_microblog/widgets/logo.dart';
import 'package:ritter_microblog/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

import '../widgets/my_buttons.dart';

class MySignupScreen extends StatefulWidget {
  const MySignupScreen({super.key});

  @override
  State<MySignupScreen> createState() => _MySignupScreenState();
}

class _MySignupScreenState extends State<MySignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void onSignupButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      try {
        await signup(
          _emailController.text,
          _passwordController.text,
        );
      } on FirebaseAuthException catch (e) {
        showInfoToast(e.message ?? "An error occurred.");

        return;
      } catch (e) {
        developer.log("Exception: ${e.toString()}",
            name: 'onSignupButtonClick');

        showInfoToast("Signup failed.");

        return;
      }

      showInfoToast("Signup success!");

      SharedPreferences.getInstance().then((prefs) {
        prefs.setString("email", _emailController.text);
        prefs.setString("password", _passwordController.text);
      });

      sendVerificationEmail();

      String uid = getSelfUid() ?? "";
      updateSelfProfileData(
        UserData(
            username: _usernameController.text,
            handle: uid.substring(0, 8),
            joinedDate: Timestamp.now()),
      );

      if (!mounted) return;

      Navigator.pushNamed(context, "/verify-email");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Ritter")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Logo(),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      MyAuthTextField(
                          padding: const EdgeInsets.only(bottom: 12),
                          controller: _emailController,
                          labelText: "Email"),
                      MyAuthTextField(
                          padding: const EdgeInsets.only(bottom: 12),
                          controller: _usernameController,
                          labelText: "Username"),
                      MyPasswordTextField(
                          padding: const EdgeInsets.only(bottom: 36),
                          controller: _passwordController),
                      MyAuthButton(
                        padding: const EdgeInsets.only(bottom: 36),
                        lable: "Signup",
                        onPressed: onSignupButtonPressed,
                      ),
                      MyTextWithButton(
                        padding: const EdgeInsets.only(bottom: 12),
                        text: "Already have an account? ",
                        buttonText: "Signin",
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, "/signin");
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
