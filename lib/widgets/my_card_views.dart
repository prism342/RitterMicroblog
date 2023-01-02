import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ritter_microblog/firebase_apis.dart';
import 'package:ritter_microblog/screens/post_detail_screen.dart';
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
  void onProfileInfoPressed() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userData = getUserDataByID(widget.userID);

    late final double profileRadius;
    late final TextStyle? usernameStyle;
    late final TextStyle? handleStyle;

    switch (widget.size) {
      case WidgetSize.large:
        profileRadius = 24;
        usernameStyle = theme.textTheme.titleMedium;
        handleStyle = theme.textTheme.labelLarge;
        break;
      case WidgetSize.medium:
        profileRadius = 22;
        usernameStyle = theme.textTheme.titleSmall;
        handleStyle = theme.textTheme.labelMedium;
        break;
      case WidgetSize.small:
        profileRadius = 20;
        usernameStyle = theme.textTheme.titleSmall;
        handleStyle = theme.textTheme.labelSmall;
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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.postID == null) {
      return Icon(Icons.messenger, color: Colors.grey.shade600);
    } else {
      return Row(
        children: [
          StreamBuilder(
            stream: isPostCommentedStream(widget.postID!),
            builder: (context, snapshot) => Icon(Icons.messenger_rounded,
                color: snapshot.data == true
                    ? theme.colorScheme.primary
                    : Colors.grey.shade600),
          ),
          StreamBuilder(
            stream: getNumberOfCommentsStream(widget.postID!),
            builder: (context, snapshot) => Text(
              " ${((snapshot.data ?? 0) == 0) ? '' : snapshot.data}",
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: theme.textTheme.bodyMedium?.fontSize),
            ),
          )
        ],
      );
    }
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

class MyMenuIconButton extends StatelessWidget {
  final PostActivity post;

  const MyMenuIconButton({super.key, required this.post});

  void onMenuButtonPressed() {}

  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    //     onTap: onMenuButtonPressed,
    //     child: Icon(
    //       Icons.more_horiz_sharp,
    //       color: Colors.grey.shade600,
    //       // size: 28,
    //     ));

    final theme = Theme.of(context);

    return PopupMenuButton<int>(
      icon: Icon(
        Icons.more_horiz_sharp,
        color: Colors.grey.shade600,
        // size: 28,
      ),
      padding: EdgeInsets.zero,
      offset: const Offset(0, 40),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text("Delete", style: theme.textTheme.bodyMedium),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("Menu Item", style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class MyTimePastText extends StatefulWidget {
  final WidgetSize size;
  final DateTime date;

  const MyTimePastText({super.key, required this.date, required this.size});

  @override
  State<MyTimePastText> createState() => _MyTimePastTextState();
}

class _MyTimePastTextState extends State<MyTimePastText> {
  late String timePast;
  late final Timer timer;

  String getTimePastString(DateTime date) {
    final currentDate = DateTime.now();
    final dateDiff = currentDate.difference(date);

    final yearDiff = (dateDiff.inDays / 365).floor();
    if (yearDiff > 0) {
      return "${yearDiff}y ago";
    }

    final monthDiff = (dateDiff.inDays / 30.5).floor();
    if (monthDiff > 0) {
      return "${monthDiff}m ago";
    }

    final daysDiff = dateDiff.inDays;
    if (daysDiff > 0) {
      return "${daysDiff}d ago";
    }

    final hoursDiff = dateDiff.inHours % 24;
    if (hoursDiff > 0) {
      return "${hoursDiff}h ago";
    }

    final minutesDiff = dateDiff.inMinutes % 60;
    if (minutesDiff > 0) {
      return "${minutesDiff}min ago";
    }

    final secondsDiff = dateDiff.inSeconds % 60;
    if (secondsDiff > 0) {
      return "${secondsDiff}s ago";
    }

    return "0s ago";
  }

  @override
  void initState() {
    super.initState();

    timePast = getTimePastString(widget.date);

    timer = Timer.periodic(const Duration(seconds: 30), (Timer t) {
      setState(() {
        timePast = getTimePastString(widget.date);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.size == WidgetSize.large) {
      return Text(timePast, style: theme.textTheme.labelLarge);
    } else if (widget.size == WidgetSize.medium) {
      return Text(timePast, style: theme.textTheme.labelMedium);
    } else {
      return Text(timePast, style: theme.textTheme.labelSmall);
    }
  }
}

class MyPostCard extends StatefulWidget {
  final PostActivity post;
  final bool disableNavigation;

  const MyPostCard(
      {super.key, required this.post, this.disableNavigation = false});

  @override
  State<MyPostCard> createState() => _MyPostCardState();
}

class _MyPostCardState extends State<MyPostCard> {
  void onPostBodyPressed() {
    if (!widget.disableNavigation) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => MyPostDetailScreen(
            post: widget.post,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onPostBodyPressed,
      child: Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyProfileWidget(
                    userID: widget.post.creatorID, size: WidgetSize.medium),
                Row(
                  children: [
                    MyTimePastText(
                      date: widget.post.timestamp.toDate(),
                      size: WidgetSize.medium,
                    ),
                    const SizedBox(width: 12),
                    MyMenuIconButton(post: widget.post)
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(widget.post.postContent, style: theme.textTheme.bodyLarge),
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
      ),
    );
  }
}

class MyCommentCard extends StatelessWidget {
  final CommentActivity? comment;

  const MyCommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (comment == null) {
      return Container();
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: theme.colorScheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 0),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyProfileWidget(
                          userID: comment!.creatorID, size: WidgetSize.small),
                      MyTimePastText(
                        date: comment!.timestamp.toDate(),
                        size: WidgetSize.small,
                      )
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    comment!.comment,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

class MyUserProfileCard extends StatefulWidget {
  final UserData userData;
  final WidgetSize size;

  const MyUserProfileCard(
      {super.key, required this.userData, required this.size});

  @override
  State<MyUserProfileCard> createState() => _MyUserProfileCardState();
}

class _MyUserProfileCardState extends State<MyUserProfileCard> {
  void onProfileInfoPressed() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        handleStyle = theme.textTheme.labelSmall;
        break;
    }

    return Container(
      // margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      color: theme.colorScheme.surface,
      child: Row(
        children: [
          MyProfilePic(
            radius: profileRadius,
            url: widget.userData.profilePicUrl,
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Text(
                widget.userData.username ?? "",
                style: usernameStyle,
              ),
              Text(
                (widget.userData.handle == null)
                    ? ""
                    : "@${widget.userData.handle}",
                style: handleStyle,
              )
            ],
          )
        ],
      ),
    );
  }
}
