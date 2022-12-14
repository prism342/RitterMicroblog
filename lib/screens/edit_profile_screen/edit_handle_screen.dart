import 'package:flutter/material.dart';
import 'package:ritter_microblog/data_models.dart';
import 'package:ritter_microblog/firebase_apis.dart';
import 'package:ritter_microblog/widgets/my_buttons.dart';

class MyEditHandleScreen extends StatefulWidget {
  final String defaultHandle;

  const MyEditHandleScreen({super.key, required this.defaultHandle});

  @override
  State<MyEditHandleScreen> createState() => _MyEditHandleScreenState();
}

class _MyEditHandleScreenState extends State<MyEditHandleScreen> {
  final TextEditingController _handleController = TextEditingController();
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
    myFocusNode.requestFocus();

    _handleController.text = widget.defaultHandle;
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  void onSaveButtonPressed() async {
    if (_handleController.text != widget.defaultHandle) {
      await updateSelfUserData(UserData(handle: _handleController.text));
    }

    if (!mounted) {
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Handle")),
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 24.0, right: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Handle",
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            TextField(
              style: theme.textTheme.bodyMedium,
              controller: _handleController,
              focusNode: myFocusNode,
              decoration: const InputDecoration(
                // icon: Icon(Icons.person),
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
