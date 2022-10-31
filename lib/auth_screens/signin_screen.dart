import 'package:flutter/material.dart';

class MySigninScreen extends StatefulWidget {
  const MySigninScreen({super.key});

  @override
  State<MySigninScreen> createState() => _MySigninScreenState();
}

class _MySigninScreenState extends State<MySigninScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("My signin screen"),
    );
  }
}
