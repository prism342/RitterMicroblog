import 'package:flutter/material.dart';

class MyExploreScreen extends StatefulWidget {
  const MyExploreScreen({super.key});

  @override
  State<MyExploreScreen> createState() => _MyExploreScreenState();
}

class _MyExploreScreenState extends State<MyExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: Text("Profile Pic"),
      //   title: const Text("Discover"),
      //   centerTitle: true,
      // ),
      body: Container(
        color: Colors.white,
        child: Text("Explore Screen"),
      ),
    );
  }
}
