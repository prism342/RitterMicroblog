import 'package:flutter/material.dart';

class MyExploreScreen extends StatefulWidget {
  const MyExploreScreen({super.key});

  @override
  State<MyExploreScreen> createState() => _MyExploreScreenState();
}

class _MyExploreScreenState extends State<MyExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Text("Explore Screen"),
    );
  }
}
