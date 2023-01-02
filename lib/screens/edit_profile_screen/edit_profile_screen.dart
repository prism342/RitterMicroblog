import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ritter_microblog/screens/edit_profile_screen/edit_handle_screen.dart';
import 'package:ritter_microblog/screens/edit_profile_screen/edit_username_screen.dart';
import 'package:ritter_microblog/widgets/my_images.dart';
import 'package:ritter_microblog/widgets/toast.dart';

import '../../data_models.dart';
import '../../firebase_apis.dart';

class MyEditProfileScreen extends StatefulWidget {
  const MyEditProfileScreen({super.key});

  @override
  State<MyEditProfileScreen> createState() => _MyEditProfileScreenState();
}

class _MyEditProfileScreenState extends State<MyEditProfileScreen> {
  final selfUserDataStream = getSelfProfileDataStream();

  Widget buildTile(String title, Widget? content, void Function() onTap,
      {Widget trailing = const Icon(Icons.keyboard_arrow_right_rounded)}) {
    final theme = Theme.of(context);

    return Column(
      children: [
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium,
              ),
              content ?? Container()
            ],
          ),
          trailing: trailing,
          onTap: onTap,
        ),
        const Divider(
          height: 0,
          indent: 16,
        )
      ],
    );
  }

  Widget streamViewBuilder(
      BuildContext context, AsyncSnapshot<UserData> snapshot) {
    final theme = Theme.of(context);

    if (snapshot.hasError) {
      return const Text('Something went wrong');
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return ListView(
        children: [
          buildTile("Profile Picture", null, () {}),
          buildTile("Username", null, () {}),
          buildTile("Handle", null, () {}),
          buildTile("Email Address", null, () {},
              trailing: const Icon(Icons.lock_outline_rounded)),
        ],
      );
    }

    return ListView(
      children: [
        buildTile(
          "Profile Picture",
          Padding(
              padding: const EdgeInsets.all(4.0),
              child: MyProfilePic(url: snapshot.data!.profilePicUrl)),
          () async {
            final ImagePicker _picker = ImagePicker();
            // Pick an image
            final XFile? image =
                await _picker.pickImage(source: ImageSource.gallery);
            log((image?.path).toString());
            if (image != null) {
              try {
                await uploadProfilePic(image.path);
                showMyToast("Update sucess");
              } catch (e) {
                showMyToast("Update failed");
              }
            }
          },
        ),
        buildTile(
            "Username",
            Text(
              snapshot.data!.username ?? "",
              style: theme.textTheme.labelMedium,
            ), () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => MyEditUsernameScreen(
                  defaultUsername: snapshot.data!.username ?? ""),
            ),
          );
        }),
        buildTile(
            "Handle",
            Text(
              snapshot.data!.handle ?? "",
              style: theme.textTheme.labelMedium,
            ), () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => MyEditHandleScreen(
                  defaultHandle: snapshot.data!.handle ?? ""),
            ),
          );
        }),
        buildTile(
            "Email Address",
            Text(
              getSelfEmail() ?? "",
              style: theme.textTheme.labelMedium,
            ),
            () {},
            trailing: const Icon(Icons.lock_outline_rounded)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit profile")),
      body: StreamBuilder(
        stream: selfUserDataStream,
        builder: streamViewBuilder,
      ),
    );
  }
}
