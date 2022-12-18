import 'package:flutter/material.dart';

class MyFeedTab extends StatefulWidget {
  const MyFeedTab({super.key});

  @override
  State<MyFeedTab> createState() => _MyFeedTabState();
}

class _MyFeedTabState extends State<MyFeedTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Text("Profile Pic"),
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
