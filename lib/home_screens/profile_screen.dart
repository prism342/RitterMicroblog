import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../my_widgets.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileTextColor = Theme.of(context).textTheme.caption?.color;
    final profileTextStyle = TextStyle(color: profileTextColor);
    int followers = 0;
    int following = 0;

    return Scaffold(
      // appBar: AppBar(
      //   leading: const Text("Profile Pic"),
      //   title: const Text("Profile"),
      //   centerTitle: true,
      // ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 100,
                color: Theme.of(context).colorScheme.background,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        MyTextButton("Edit"),
                      ],
                    ),
                    Text(
                      "Username",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Text("@${FirebaseAuth.instance.currentUser?.uid}",
                        style: profileTextStyle),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            color: profileTextColor,
                            size: 20,
                          ),
                          Text("  ", style: profileTextStyle),
                          Text("Joined date", style: profileTextStyle)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Text("$followers"),
                          Text(
                            " Followers",
                            style: profileTextStyle,
                          ),
                          Text(
                            "   ",
                            style: profileTextStyle,
                          ),
                          Text("$following"),
                          Text(" Following", style: profileTextStyle)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 32),
                child: Row(children: [
                  Text(
                    "Activities",
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ]),
              ),
              Divider(
                thickness: 2,
              ),
            ],
          ),
          Container(
            child: Text("ProfilePic"),
            color: Colors.amber,
            height: 50,
            width: 50,
            margin: EdgeInsets.only(left: 24, top: 75),
          ),
        ],
      ),
    );
  }
}
