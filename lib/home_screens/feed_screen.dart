import 'package:flutter/material.dart';

class MyFeedScreen extends StatefulWidget {
  const MyFeedScreen({super.key});

  @override
  State<MyFeedScreen> createState() => _MyFeedScreenState();
}

class _MyFeedScreenState extends State<MyFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text("Profile Pic"),
        title: const Text("Feed"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Text("Home Screen"),
      ),
    );
  }
}
