import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ritter_microblog/firebase_apis.dart';
import 'package:ritter_microblog/widgets/my_card_views.dart';
import 'package:tuple/tuple.dart';

import '../../data_models.dart';

class MyFeedTab extends StatefulWidget {
  const MyFeedTab({super.key});

  @override
  State<MyFeedTab> createState() => _MyFeedTabState();
}

class _MyFeedTabState extends State<MyFeedTab> {
  final myFeedStream = getLatestFeedStream();

  Widget postListBuilder(
      BuildContext context, AsyncSnapshot<List<PostActivity?>> snapshot) {
    if (snapshot.hasData && snapshot.data != null) {
      final feeds = snapshot.data!;
      return ListView.builder(
          itemCount: feeds.length,
          itemBuilder: (context, index) => (feeds[index] == null)
              ? Container()
              : MyPostCard(post: feeds[index]!));
    } else {
      return Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: 24),
        child: Text("Loading..."),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        // leading: Text("Profile Pic"),
        title: const Text("Feed"),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
          color: theme.colorScheme.background,
          child: StreamBuilder(stream: myFeedStream, builder: postListBuilder)),
    );
  }
}
