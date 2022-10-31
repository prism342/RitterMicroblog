import 'package:flutter/material.dart';
import 'package:ritter_microblog/home_screens/explore_screen.dart';
import 'package:ritter_microblog/home_screens/feed_screen.dart';
import 'package:ritter_microblog/home_screens/notifications_screen.dart';
import 'package:ritter_microblog/home_screens/profile_screen.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  int _selectedTabIndex = 0;

  void _onBottomBarTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  final screens = const [
    MyFeedScreen(),
    MyExploreScreen(),
    MyNotificationsScreen(),
    MyProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedTabIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/new-post");
        },
        tooltip: 'New post',
        child: const Icon(Icons.add_comment_rounded, size: 30),
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
        // selectedItemColor: Colors.amber[800],
        // unselectedItemColor: Colors.grey[500],
        showUnselectedLabels: false,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: _onBottomBarTapped,
      ),
    );
  }
}
