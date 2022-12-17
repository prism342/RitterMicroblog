import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ritter_microblog/firebase_apis.dart';
import 'package:ritter_microblog/widgets/my_text_fields.dart';
import 'package:ritter_microblog/widgets/logo.dart';
import 'package:ritter_microblog/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/my_buttons.dart';

class MySigninScreen extends StatefulWidget {
  const MySigninScreen({super.key});

  @override
  State<MySigninScreen> createState() => _MySigninScreenState();
}

class _MySigninScreenState extends State<MySigninScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void onSigninButtonClick() async {
    _formKey.currentState!.validate();

    try {
      await signin(_emailController.text, _passwordController.text);
    } on FirebaseAuthException catch (e) {
      showInfoToast(e.message ?? "An error occured");
      return;
    } catch (e) {
      showInfoToast("Signin failed");
      return;
    }

    showInfoToast("Signin sucess!");

    log(isEmailVerified().toString(), name: "email verified");

    if (!mounted) return;

    log(isEmailVerified().toString(), name: "email verified");

    if (isEmailVerified() ?? false) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      Navigator.pushNamed(context, "/verify-email");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      _emailController.text = prefs.getString("email") ?? "";
      _passwordController.text = prefs.getString("password") ?? "";
    });
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
                      MyPasswordTextField(
                          padding: const EdgeInsets.only(bottom: 36),
                          controller: _passwordController),
                      MyAuthButton(
                        padding: const EdgeInsets.only(bottom: 36),
                        lable: "Signin",
                        onPressed: onSigninButtonClick,
                      ),
                      MyTextWithButton(
                        text: "Don't have an account? ",
                        buttonText: "Signup",
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, "/signup");
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
