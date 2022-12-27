import 'package:flutter/material.dart';

class MyProfilePic extends StatelessWidget {
  final double? radius;
  final String? url;

  const MyProfilePic({super.key, this.radius = 25, this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage:
            const AssetImage("assets/images/profile-picture-placeholder.png"),
      );
    } else {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(url!),
      );
    }
  }
}
