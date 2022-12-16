import 'package:flutter/material.dart';

class MyNotificationsScreen extends StatefulWidget {
  const MyNotificationsScreen({super.key});

  @override
  State<MyNotificationsScreen> createState() => _MyNotificationsScreenState();
}

class _MyNotificationsScreenState extends State<MyNotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: Text("Profile Pic"),
      //   title: const Text("Notifications"),
      //   centerTitle: true,
      // ),
      body: Container(
        color: Colors.white,
        child: Text("Notifications Screen"),
      ),
    );
  }
}
