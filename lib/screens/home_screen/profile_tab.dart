import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ritter_microblog/widgets/stream_data_widgets.dart';

import '../../firebase_apis.dart';
import '../../widgets/my_buttons.dart';

class MyProfileTab extends StatefulWidget {
  const MyProfileTab({super.key});

  @override
  State<MyProfileTab> createState() => _MyProfileTabState();
}

class _MyProfileTabState extends State<MyProfileTab> {
  final selfUserDataStream = getSelfProfileDataStream();

  void onEditButtonPress() {
    Navigator.pushNamed(context, '/edit-profile');
  }

  @override
  Widget build(BuildContext context) {
    final profileTextColor = Theme.of(context).textTheme.caption?.color;
    final profileTextStyle = TextStyle(color: profileTextColor);
    int followers = 0;
    int following = 0;

    return Scaffold(
      appBar: AppBar(
        // leading: const Text("Profile Pic"),
        title: const Text("Profile"),
        centerTitle: true,
      ),
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: MySmallButton(
                        "Edit",
                        onPressed: onEditButtonPress,
                      ),
                    ),
                    MyStreamDataUsername(
                      usernameStream:
                          selfUserDataStream.map((value) => value.username),
                    ),
                    MyStreamDataUserHandle(
                      userHandleStream:
                          selfUserDataStream.map((value) => value.handle),
                    ),
                    SizedBox(height: 8),
                    MyStreamDataJoinedDate(
                      joinedDateStream:
                          selfUserDataStream.map((value) => value.joinedDate),
                    ),
                    SizedBox(height: 8),
                    Row(
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
              Divider(thickness: 2),
            ],
          ),
          MyStreamDataProfilePicture(
            profilePicUrlStream:
                selfUserDataStream.map((value) => value.profilePicUrl),
          ),
        ],
      ),
    );
  }
}
