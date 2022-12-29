import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ritter_microblog/firebase_apis.dart';
import 'package:ritter_microblog/widgets/my_images.dart';
import 'package:ritter_microblog/widgets/toast.dart';

import '../data_models.dart';

class MyPostCardView extends StatefulWidget {
  final PostActivity post;
  final UserData creator;

  const MyPostCardView({super.key, required this.post, required this.creator});

  @override
  State<MyPostCardView> createState() => _MyPostCardViewState();
}

class _MyPostCardViewState extends State<MyPostCardView> {
  void onPostBodyPressed() {}

  void onProfileInfoPressed() {}

  void onCommentButtonPressed() {}

  void onRepostButtonPressed() {}

  void onLikeButtonPressed() async {
    if (widget.post.docID != null) {
      await togglePostLike(widget.post.docID!);
    }
  }

  void onShareButtonPressed() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Theme.of(context).cardColor,
      // decoration: ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MyProfilePic(
                url: widget.creator.profilePicUrl,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.creator.username ?? "",
                      style: TextStyle(
                        fontSize: theme.textTheme.bodyLarge?.fontSize,
                        color: theme.textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "@${widget.creator.handle}",
                          style: TextStyle(
                              fontSize: theme.textTheme.bodyLarge?.fontSize,
                              color: theme.textTheme.caption?.color),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text("1s ago",
                                style: TextStyle(
                                    fontSize:
                                        theme.textTheme.bodyLarge?.fontSize,
                                    color: theme.textTheme.caption?.color)),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(widget.post.postContent),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onCommentButtonPressed,
                child: Icon(Icons.messenger, color: theme.hintColor),
              ),
              GestureDetector(
                  onTap: onRepostButtonPressed,
                  child: Icon(Icons.reply_all, color: theme.hintColor)),
              GestureDetector(
                  onTap: onLikeButtonPressed,
                  child: StreamBuilder(
                    stream: isPostlikedStream(widget.post.docID ?? ""),
                    builder: (context, snapshot) => Icon(Icons.favorite,
                        color: snapshot.data == true
                            ? Colors.red
                            : theme.hintColor),
                  )),
              GestureDetector(
                  onTap: onShareButtonPressed,
                  child: Icon(Icons.share, color: theme.hintColor))
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
