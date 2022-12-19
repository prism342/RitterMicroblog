import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ritter_microblog/data_models.dart';

import '../firebase_apis.dart';

class MyStreamDataProfilePicture extends StatelessWidget {
  final Stream<String?> profilePicUrlStream;

  const MyStreamDataProfilePicture(
      {super.key, required this.profilePicUrlStream});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      margin: const EdgeInsets.only(left: 24, top: 75),
      child: StreamBuilder<String?>(
        stream: profilePicUrlStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Image.network(snapshot.data!);
          } else {
            return Image.asset("assets/images/profile-picture-placeholder.png");
          }
        },
      ),
    );
  }
}

class MyStreamDataUsername extends StatelessWidget {
  final Stream<String?> usernameStream;
  final TextStyle? textStyle;

  const MyStreamDataUsername(
      {super.key, required this.usernameStream, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: usernameStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Text(snapshot.data!,
              style: textStyle ?? Theme.of(context).textTheme.headline5);
        } else {
          return Text("",
              style: textStyle ?? Theme.of(context).textTheme.headline5);
        }
      },
    );
  }
}

class MyStreamDataUserHandle extends StatelessWidget {
  final Stream<String?> userHandleStream;
  final TextStyle? textStyle;

  const MyStreamDataUserHandle(
      {super.key, required this.userHandleStream, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: userHandleStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Text(
            "@${snapshot.data!}",
            style: textStyle ??
                TextStyle(color: Theme.of(context).textTheme.caption?.color),
          );
        } else {
          return Text(
            "handle",
            style: textStyle ??
                TextStyle(color: Theme.of(context).textTheme.caption?.color),
          );
        }
      },
    );
  }
}

class MyStreamDataJoinedDate extends StatelessWidget {
  final Stream<Timestamp?> joinedDateStream;
  final TextStyle? textStyle;
  final Color? color;

  const MyStreamDataJoinedDate(
      {super.key, required this.joinedDateStream, this.textStyle, this.color});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Timestamp?>(
      stream: joinedDateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
              snapshot.data!.millisecondsSinceEpoch);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                Icons.calendar_month_rounded,
                color: color ?? Theme.of(context).textTheme.caption?.color,
                size: 20,
              ),
              Text(
                "  ",
                style: TextStyle(
                    color: color ?? Theme.of(context).textTheme.caption?.color),
              ),
              Text(
                "${dateTime.month}/${dateTime.day}/${dateTime.year}",
                style: TextStyle(
                    color: color ?? Theme.of(context).textTheme.caption?.color),
              )
            ],
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                Icons.calendar_month_rounded,
                color: color ?? Theme.of(context).textTheme.caption?.color,
                size: 20,
              ),
              Text(
                "  ",
                style: TextStyle(
                    color: color ?? Theme.of(context).textTheme.caption?.color),
              ),
              Text(
                "Joined date",
                style: TextStyle(
                    color: color ?? Theme.of(context).textTheme.caption?.color),
              )
            ],
          );
        }
      },
    );
  }
}
