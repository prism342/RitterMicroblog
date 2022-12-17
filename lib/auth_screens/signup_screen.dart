import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ritter_microblog/firebase_apis.dart';
import 'package:ritter_microblog/widgets/my_text_fields.dart';
import 'package:ritter_microblog/widgets/logo.dart';
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

  void onSignupButtonClick() async {
    if (_formKey.currentState!.validate()) {
      try {
        await signup(
          _emailController.text,
          _passwordController.text,
        );
        await sendVerificationEmail();
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(
          msg: e.message ?? "An error occurred.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // backgroundColor: Colors.red,
          // textColor: Colors.white,
        );
        return;
      } catch (e) {
        developer.log("Exception: ${e.toString()}",
            name: 'onSignupButtonClick');

        Fluttertoast.showToast(
          msg: "Signup failed.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }

      Fluttertoast.showToast(
        msg: "Signup success!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("email", _emailController.text);
      prefs.setString("password", _passwordController.text);

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
                        onPressed: onSignupButtonClick,
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
