import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ritter_microblog/firebase_apis.dart';
import 'package:ritter_microblog/widgets/my_images.dart';
import 'package:ritter_microblog/widgets/toast.dart';

import 'package:share_plus/share_plus.dart';

import '../data_models.dart';

enum WidgetSize { large, medium, small }

class MyProfileWidget extends StatefulWidget {
  final String userID;
  final WidgetSize size;

  const MyProfileWidget({super.key, required this.userID, required this.size});

  @override
  State<MyProfileWidget> createState() => _MyProfileWidgetState();
}

class _MyProfileWidgetState extends State<MyProfileWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userData = getUserDataByID(widget.userID);

    late final double profileRadius;
    late final TextStyle? usernameStyle;
    late final TextStyle? handleStyle;

    switch (widget.size) {
      case WidgetSize.large:
        profileRadius = 30;
        usernameStyle = theme.textTheme.titleMedium;
        handleStyle = theme.textTheme.labelLarge;
        break;
      case WidgetSize.medium:
        profileRadius = 25;
        usernameStyle = theme.textTheme.titleSmall;
        handleStyle = theme.textTheme.labelMedium;
        break;
      case WidgetSize.small:
        profileRadius = 20;
        usernameStyle = theme.textTheme.titleSmall;
        handleStyle = theme.textTheme.labelMedium;
        break;
    }

    return FutureBuilder(
      future: userData,
      builder: (context, snapshot) => Row(
        children: [
          MyProfilePic(
            radius: profileRadius,
            url: snapshot.data?.profilePicUrl,
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Text(
                snapshot.data?.username ?? "",
                style: usernameStyle,
              ),
              Text(
                (snapshot.data?.handle == null)
                    ? ""
                    : "@${snapshot.data?.handle}",
                style: handleStyle,
              )
            ],
          )
        ],
      ),
    );
  }
}

class MyCommentIconButton extends StatefulWidget {
  final String? postID;

  const MyCommentIconButton({super.key, required this.postID});

  @override
  State<MyCommentIconButton> createState() => _MyCommentIconButtonState();
}

class _MyCommentIconButtonState extends State<MyCommentIconButton> {
  void onCommentButtonPressed() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCommentButtonPressed,
      child: Icon(Icons.messenger, color: Colors.grey.shade600),
    );
  }
}

class MyRepostIconButton extends StatefulWidget {
  final String? postID;
  const MyRepostIconButton({super.key, required this.postID});

  @override
  State<MyRepostIconButton> createState() => _MyRepostIconButtonState();
}

class _MyRepostIconButtonState extends State<MyRepostIconButton> {
  void onRepostButtonPressed() async {
    if (widget.postID != null) {
      await togglePostRepost(widget.postID!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.postID == null) {
      return Icon(Icons.reply_all, color: Colors.grey.shade600);
    } else {
      return GestureDetector(
        onTap: onRepostButtonPressed,
        child: Row(
          children: [
            StreamBuilder(
              stream: isPostRepostedStream(widget.postID!),
              builder: (context, snapshot) => Icon(Icons.reply_all,
                  color: snapshot.data == true
                      ? theme.colorScheme.primary
                      : Colors.grey.shade600),
            ),
            StreamBuilder(
              stream: getNumberOfRepostsStream(widget.postID!),
              builder: (context, snapshot) => Text(
                " ${((snapshot.data ?? 0) == 0) ? '' : snapshot.data}",
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: theme.textTheme.bodyMedium?.fontSize),
              ),
            )
          ],
        ),
      );
    }
  }
}

class MyLikeIconButton extends StatefulWidget {
  final String? postID;
  const MyLikeIconButton({super.key, required this.postID});

  @override
  State<MyLikeIconButton> createState() => _MyLikeIconButtonState();
}

class _MyLikeIconButtonState extends State<MyLikeIconButton> {
  void onLikeButtonPressed() async {
    if (widget.postID != null) {
      await togglePostLike(widget.postID!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.postID == null) {
      return Icon(Icons.favorite, color: Colors.grey.shade600);
    } else {
      return GestureDetector(
        onTap: onLikeButtonPressed,
        child: Row(
          children: [
            StreamBuilder(
              stream: isPostlikedStream(widget.postID!),
              builder: (context, snapshot) => Icon(Icons.favorite,
                  color: snapshot.data == true
                      ? Colors.red
                      : Colors.grey.shade600),
            ),
            StreamBuilder(
              stream: getNumberOfLikesStream(widget.postID!),
              builder: (context, snapshot) => Text(
                  " ${((snapshot.data ?? 0) == 0) ? '' : snapshot.data}",
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: theme.textTheme.bodyMedium?.fontSize)),
            )
          ],
        ),
      );
    }
  }
}

class MyShareIconButton extends StatelessWidget {
  final PostActivity post;

  const MyShareIconButton({super.key, required this.post});

  void onShareButtonPressed() {
    Share.share("${post.postContent}\n${post.timestamp.toDate()}");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onShareButtonPressed,
        child: Icon(Icons.share, color: Colors.grey.shade600));
  }
}

class MyPostCardView extends StatefulWidget {
  final PostActivity post;

  const MyPostCardView({super.key, required this.post});

  @override
  State<MyPostCardView> createState() => _MyPostCardViewState();
}

class _MyPostCardViewState extends State<MyPostCardView> {
  void onPostBodyPressed() {}

  void onProfileInfoPressed() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(
            color: Theme.of(context).cardColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      // decoration: ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyProfileWidget(
              userID: widget.post.creatorID, size: WidgetSize.medium),
          const SizedBox(height: 24),
          Text(widget.post.postContent, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyCommentIconButton(postID: widget.post.docID),
              MyRepostIconButton(postID: widget.post.docID),
              MyLikeIconButton(postID: widget.post.docID),
              MyShareIconButton(post: widget.post),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
