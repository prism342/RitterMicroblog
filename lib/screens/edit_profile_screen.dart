import 'package:flutter/material.dart';
import 'package:ritter_microblog/screens/edit_handle_screen.dart';
import 'package:ritter_microblog/screens/edit_username_screen.dart';

import '../data_models.dart';
import '../firebase_apis.dart';

class MyEditProfileScreen extends StatefulWidget {
  const MyEditProfileScreen({super.key});

  @override
  State<MyEditProfileScreen> createState() => _MyEditProfileScreenState();
}

class _MyEditProfileScreenState extends State<MyEditProfileScreen> {
  final selfUserDataStream = getSelfProfileDataStream();

  Widget buildTile(String title, Widget? content, void Function() onTap,
      {Widget trailing = const Icon(Icons.keyboard_arrow_right_rounded)}) {
    return Column(
      children: [
        ListTile(
          title: content == null
              ? Text(title)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(title), content],
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
        buildTile("Profile Picture", null, () {}),
        buildTile(
            "Username",
            Text(
              snapshot.data!.username ?? "",
              style:
                  TextStyle(color: Theme.of(context).textTheme.caption?.color),
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
              style:
                  TextStyle(color: Theme.of(context).textTheme.caption?.color),
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
              style:
                  TextStyle(color: Theme.of(context).textTheme.caption?.color),
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
