import 'package:flutter/material.dart';

class MyExploreTab extends StatefulWidget {
  const MyExploreTab({super.key});

  @override
  State<MyExploreTab> createState() => _MyExploreTabState();
}

class _MyExploreTabState extends State<MyExploreTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Text("Profile Pic"),
        title: const Text("Discover"),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        color: Colors.white,
        child: Text("Explore Screen"),
      ),
    );
  }
}
