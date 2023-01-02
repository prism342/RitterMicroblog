import 'package:flutter/material.dart';
import 'package:ritter_microblog/data_models.dart';
import 'package:ritter_microblog/firebase_apis.dart';
import 'package:ritter_microblog/widgets/my_buttons.dart';

class MyEditUsernameScreen extends StatefulWidget {
  final String defaultUsername;

  const MyEditUsernameScreen({super.key, required this.defaultUsername});

  @override
  State<MyEditUsernameScreen> createState() => _MyEditUsernameScreenState();
}

class _MyEditUsernameScreenState extends State<MyEditUsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
    myFocusNode.requestFocus();

    _usernameController.text = widget.defaultUsername;
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  void onSaveButtonPressed() async {
    if (_usernameController.text != widget.defaultUsername) {
      await updateSelfUserData(UserData(username: _usernameController.text));
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Username")),
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 24.0, right: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Username",
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            TextField(
              style: theme.textTheme.bodyMedium,
              controller: _usernameController,
              focusNode: myFocusNode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            MyAuthButton(lable: "Save", onPressed: onSaveButtonPressed)
          ],
        ),
      ),
    );
  }
}
