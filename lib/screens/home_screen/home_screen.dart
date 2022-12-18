import 'package:flutter/material.dart';

import 'my_drawer.dart';
import 'feed_tab.dart';
import 'explore_tab.dart';
import 'notifications_tab.dart';
import 'profile_tab.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  int _selectedTabIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onBottomBarTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  final _screenTitles = const ["Feed", "Explore", "Notifications", "Profile"];

  final _screens = const [
    MyFeedTab(),
    MyExploreTab(),
    MyNotificationsTab(),
    MyProfileTab()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   leading: GestureDetector(
      //     child: Text(
      //       "Profile Pic",
      //       // style: TextStyle(color: Theme.of(context).primaryColor),
      //     ),
      //     onTap: () => _scaffoldKey.currentState?.openDrawer(),
      //   ),
      //   title: Text(
      //     _screenTitles[_selectedTabIndex],
      //     // style: TextStyle(color: Theme.of(context).primaryColor),
      //   ),
      //   centerTitle: true,
      //   elevation: 1,
      // ),
      // drawer: MyDrawer(),
      body: _screens[_selectedTabIndex],
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
