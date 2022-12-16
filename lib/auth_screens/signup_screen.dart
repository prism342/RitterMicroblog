import 'package:flutter/material.dart';
import 'package:ritter_microblog/widgets/my_text_fields.dart';
import 'package:ritter_microblog/widgets/logo.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Ritter")),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(children: [
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
                    onPressed: () => {_formKey.currentState!.validate()},
                  ),
                  MyTextWithButton(
                    text: "Already have an account? ",
                    buttonText: "Signin",
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/signin");
                    },
                  )
                ],
              ))
        ]),
      )),
    );
  }
}
