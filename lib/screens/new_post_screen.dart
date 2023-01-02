import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ritter_microblog/widgets/my_buttons.dart';
import 'package:ritter_microblog/widgets/toast.dart';
import '../data_models.dart';
import '../firebase_apis.dart';
import '../widgets/my_images.dart';

class MyNewPostScreen extends StatefulWidget {
  const MyNewPostScreen({super.key});

  @override
  State<MyNewPostScreen> createState() => _MyNewPostScreenState();
}

class _MyNewPostScreenState extends State<MyNewPostScreen> {
  final selfUserDataStream = getSelfProfileDataStream();
  final contentTextController = TextEditingController();
  final selectedImageList = <String>[];

  Widget buildUsernameHeader(UserData userData) {
    return Row(
      children: [
        MyProfilePic(
          url: userData.profilePicUrl,
          radius: 20,
        ),
        const SizedBox(width: 12),
        Text(userData.username ?? "", style: TextStyle(fontSize: 20)),
      ],
    );
  }

  void onPostButtonPressed() async {
    try {
      await createPost(contentTextController.text, []);
      //showInfoToast("");
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      showMyToast("Create post failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "New Post",
            textAlign: TextAlign.center,
          ),
          elevation: 2,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 24),
              StreamBuilder(
                stream: selfUserDataStream,
                builder:
                    (BuildContext context, AsyncSnapshot<UserData> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return buildUsernameHeader(snapshot.data!);
                  } else {
                    return buildUsernameHeader(
                      UserData(username: ""),
                    );
                  }
                },
              ),
              // const SizedBox(height: 8),
              TextFormField(
                controller: contentTextController,
                minLines: 4,
                maxLines: 6,
                maxLength: 500,
                style: TextStyle(fontSize: 22),
                strutStyle: StrutStyle(),
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                        // borderSide: BorderSide(color: Colors.pink[400]!)
                        ),
                    labelText: "Write something...",
                    // fillColor: Colors.pink[400],
                    labelStyle: TextStyle(color: theme.colorScheme.secondary),
                    alignLabelWithHint: true
                    // focusColor: Colors.pink[400],
                    ),
                // cursorColor: Colors.pink[400],
              ),
              Row(
                children: [
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.image_rounded,
                      color: theme.colorScheme.secondary,
                      size: 30,
                    ),
                  ),
                  // const Text(" Add image"),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: MySmallButton(
                    "Post",
                    onPressed: onPostButtonPressed,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
