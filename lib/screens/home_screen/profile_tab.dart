import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ritter_microblog/widgets/my_images.dart';

import '../../data_models.dart';
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

  Widget buildProfileSection(UserData userData) {
    final profileTextColor = Theme.of(context).textTheme.caption?.color;
    final profileTextStyle = TextStyle(color: profileTextColor);
    int followers = 0;
    int following = 0;

    String joinedDateStr = "";
    if (userData.joinedDate != null) {
      DateTime joinedDate = DateTime.fromMillisecondsSinceEpoch(
          userData.joinedDate!.millisecondsSinceEpoch);
      joinedDateStr =
          "${joinedDate.month}/${joinedDate.day}/${joinedDate.year}";
    }

    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 100,
              color: Theme.of(context).colorScheme.background,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: MySmallButton(
                  "Edit",
                  onPressed: onEditButtonPress,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userData.username ?? "",
                      style: Theme.of(context).textTheme.headline5),
                  Text(
                    "@${userData.handle ?? ""}",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.caption?.color),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: Theme.of(context).textTheme.caption?.color,
                        size: 20,
                      ),
                      Text(
                        "  $joinedDateStr",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.caption?.color),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
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
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 70, left: 25),
          child: MyProfilePic(
            url: userData.profilePicUrl,
            radius: 30,
          ),
        ),
      ],
    );
  }

  Widget buildActivitiesSection() {
    return Column(
      children: [
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: const Text("Profile Pic"),
        title: const Text("Profile"),
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: selfUserDataStream,
            builder: (BuildContext context, AsyncSnapshot<UserData> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return buildProfileSection(snapshot.data!);
              } else {
                return buildProfileSection(
                  UserData(
                    username: "",
                    handle: "@handle",
                    joinedDate: Timestamp.now(),
                  ),
                );
              }
            },
          ),
          buildActivitiesSection(),
        ],
      ),
    );
  }
}
