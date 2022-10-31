import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton(
    this.title, {
    Key? key,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  final String title;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    Color? effectiveBackgroundColor = backgroundColor;
    if (backgroundColor == null) {
      effectiveBackgroundColor = Theme.of(context).colorScheme.background;
    }
    Color? effectiveTextColor = backgroundColor;
    if (textColor == null) {
      effectiveTextColor = Theme.of(context).colorScheme.onBackground;
    }

    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(effectiveBackgroundColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ))),
      child: Text(
        title,
        style: TextStyle(color: effectiveTextColor),
      ),
    );
  }
}
