import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Item 1'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Icon(
                Icons.logout,
                // size: Theme.of(context).iconTheme.size,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            // dense: true,
            // minLeadingWidth: 32,
            // horizontalTitleGap: 20,
            onTap: () {
              // Update the state of the app.
              // ...
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/signin');
            },
          ),
        ],
      ),
    );
  }
}
