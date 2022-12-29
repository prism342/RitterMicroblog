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
    final theme = Theme.of(context);

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
                      style: theme.textTheme.titleMedium),
                  Text(
                    "@${userData.handle ?? ""}",
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: theme.textTheme.labelMedium?.color,
                        size: 20,
                      ),
                      Text(
                        "  $joinedDateStr",
                        style: theme.textTheme.labelMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text("$followers", style: theme.textTheme.bodyMedium),
                      Text(
                        " Followers",
                        style: theme.textTheme.labelMedium,
                      ),
                      Text(
                        "   ",
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text("$following", style: theme.textTheme.bodyMedium),
                      Text(" Following", style: theme.textTheme.labelMedium)
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
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 32),
          child: Row(children: [
            Text(
              "Activities",
              style: theme.textTheme.titleMedium,
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
