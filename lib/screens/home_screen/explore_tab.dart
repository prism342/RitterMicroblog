import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ritter_microblog/data_models.dart';
import 'package:ritter_microblog/firebase_apis.dart';
import 'package:ritter_microblog/widgets/my_card_views.dart';
import 'package:ritter_microblog/widgets/my_text_fields.dart';

class MyExploreTab extends StatefulWidget {
  const MyExploreTab({super.key});

  @override
  State<MyExploreTab> createState() => _MyExploreTabState();
}

class _MyExploreTabState extends State<MyExploreTab> {
  final textController = TextEditingController();
  int selectedTabIndex = 0;
  bool isSearchButtonPressed = false;
  List<PostActivity?>? posts;
  List<UserData?>? users;

  Future<void> onSearchButtonPressed() async {
    if (textController.text == "") return;

    setState(() {
      isSearchButtonPressed = true;
    });

    posts = null;
    users = null;

    searchPosts(textController.text).then((searchedPosts) {
      log(searchedPosts.toString());
      setState(() {
        posts = searchedPosts;
      });
    });

    searchUsers(textController.text).then((searchedUsers) {
      log(searchedUsers.toString());
      setState(() {
        users = searchedUsers;
      });
    });

    // textController.text = "";

    return;
  }

  Widget buildListOfPostsTab(List<PostActivity?>? posts) {
    if (posts == null) {
      return Text("Searching...");
    } else {
      return SingleChildScrollView(
        child: Column(
          children: posts
              .map((post) =>
                  (post == null) ? Container() : MyPostCard(post: post))
              .toList(),
        ),
      );
    }
  }

  Widget buildListOfUsersTab(List<UserData?>? users) {
    if (users == null) {
      return Text("Searching...");
    } else {
      return SingleChildScrollView(
        child: Column(
          children: users
              .map((user) => (user == null)
                  ? Container()
                  : Column(
                      children: [
                        Divider(height: 0),
                        MyUserProfileCard(
                          userData: user,
                          size: WidgetSize.medium,
                        ),
                      ],
                    ))
              .toList(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // leading: Text("Profile Pic"),
          title: const Text("Discover"),
          centerTitle: true,
          elevation: 2,
        ),
        body: Column(
          children: [
            MySearchTextField(
              textController: textController,
              onSearchButtonPressed: onSearchButtonPressed,
            ),
            Builder(
                builder: (context) => isSearchButtonPressed
                    ? Column(children: [
                        Container(
                          color: theme.colorScheme.surface,
                          child: TabBar(
                            onTap: (index) {
                              setState(() {
                                selectedTabIndex = index;
                              });
                            },
                            tabs: [
                              Tab(
                                  child: Text("posts",
                                      style: theme.textTheme.labelMedium)),
                              Tab(
                                child: Text("users",
                                    style: theme.textTheme.labelMedium),
                              )
                            ],
                          ),
                        ),
                        Container(
                          color: theme.colorScheme.background,
                          child: Builder(builder: (context) {
                            switch (selectedTabIndex) {
                              case 0:
                                return buildListOfPostsTab(posts);
                              case 1:
                                return buildListOfUsersTab(users);
                              default:
                                return Container();
                            }
                          }),
                        )
                      ])
                    : Container())
          ],
        ),
      ),
    );
  }
}
