import 'package:flutter/material.dart';
import 'package:ritter_microblog/widgets/my_text_fields.dart';
import 'package:ritter_microblog/widgets/logo.dart';

import '../widgets/my_buttons.dart';

class MySigninScreen extends StatefulWidget {
  const MySigninScreen({super.key});

  @override
  State<MySigninScreen> createState() => _MySigninScreenState();
}

class _MySigninScreenState extends State<MySigninScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                      controller: _usernameController,
                      labelText: "Username"),
                  MyPasswordTextField(
                      padding: const EdgeInsets.only(bottom: 36),
                      controller: _passwordController),
                  MyAuthButton(
                    padding: const EdgeInsets.only(bottom: 36),
                    lable: "Signin",
                    onPressed: () => {_formKey.currentState!.validate()},
                  ),
                  MyTextWithButton(
                    text: "Don't have an account? ",
                    buttonText: "Signup",
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/signup");
                    },
                  )
                ],
              ))
        ]),
      )),
    );
  }
}
