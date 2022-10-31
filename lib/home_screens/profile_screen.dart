import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text("Profile Pic"),
        title: const Text("Profile"),
        centerTitle: true,
        // actions: [
        //   IconButton(onPressed: () {}, icon: Icon(Icons.settings_rounded))
        // ],
      ),
      body: Container(
        color: Colors.white,
        child: Text("Profile Screen"),
      ),
    );
  }
}
