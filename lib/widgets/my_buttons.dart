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
      effectiveBackgroundColor = Theme.of(context).colorScheme.primary;
    }
    Color? effectiveTextColor = backgroundColor;
    if (textColor == null) {
      effectiveTextColor = Theme.of(context).colorScheme.onPrimary;
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

class MyAuthButton extends StatelessWidget {
  final String lable;
  final void Function() onPressed;
  final double height;
  final EdgeInsets padding;
  const MyAuthButton(
      {super.key,
      required this.lable,
      required this.onPressed,
      this.height = 40,
      this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: ElevatedButton(
          style: ButtonStyle(),
          onPressed: onPressed,
          child: Text(lable),
        ),
      ),
    );
  }
}

class MyTextWithButton extends StatelessWidget {
  final String text;
  final String buttonText;
  final void Function() onPressed;
  const MyTextWithButton(
      {super.key,
      required this.text,
      required this.buttonText,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        GestureDetector(
          onTap: onPressed,
          child: Text(
            buttonText,
            style: TextStyle(color: themeData.buttonTheme.colorScheme!.primary),
          ),
        )
      ],
    );
  }
}
