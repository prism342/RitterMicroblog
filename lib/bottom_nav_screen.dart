import 'package:flutter/material.dart';
import 'package:ritter_microblog/explore_screen.dart';
import 'package:ritter_microblog/home_screen.dart';
import 'package:ritter_microblog/notifications_screen.dart';
import 'package:ritter_microblog/profile_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedTabIndex = 0;

  void _onBottomBarTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  final screens = const [
    MyHomeScreen(),
    MyExploreScreen(),
    MyNotificationsScreen(),
    MyProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: screens[_selectedTabIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'New post',
        child: const Icon(Icons.note_add_rounded),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded, size: 30),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_rounded, size: 30),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded, size: 30),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedTabIndex,
        selectedItemColor: Colors.amber[800],
        // unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: _onBottomBarTapped,
      ),
    );
  }
}
