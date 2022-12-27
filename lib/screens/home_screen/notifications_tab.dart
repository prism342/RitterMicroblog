import 'package:flutter/material.dart';

class MyNotificationsTab extends StatefulWidget {
  const MyNotificationsTab({super.key});

  @override
  State<MyNotificationsTab> createState() => _MyNotificationsTabState();
}

class _MyNotificationsTabState extends State<MyNotificationsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Text("Profile Pic"),
        title: const Text("Notifications"),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        color: Colors.white,
        child: Text("Notifications Screen"),
      ),
    );
  }
}
