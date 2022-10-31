import 'package:flutter/material.dart';

class MySignupScreen extends StatefulWidget {
  const MySignupScreen({super.key});

  @override
  State<MySignupScreen> createState() => _MySignupScreenState();
}

class _MySignupScreenState extends State<MySignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("My signup screen"),
    );
  }
}
