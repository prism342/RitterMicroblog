import 'package:flutter/material.dart';

class MyEditProfileScreen extends StatefulWidget {
  const MyEditProfileScreen({super.key});

  @override
  State<MyEditProfileScreen> createState() => _MyEditProfileScreenState();
}

class _MyEditProfileScreenState extends State<MyEditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit profile")),
      body: Container(
        child: const Text("Edit profile screen"),
      ),
    );
  }
}
