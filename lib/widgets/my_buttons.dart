import 'package:flutter/material.dart';

class MySmallButton extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final Color? textColor;
  final void Function() onPressed;

  const MySmallButton(
    this.title, {
    Key? key,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

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
      onPressed: onPressed,
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
      this.height = 42,
      this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Padding(
      padding: padding,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: ElevatedButton(
          // style: ButtonStyle(),
          onPressed: onPressed,
          child: Text(
            lable,
            style:
                TextStyle(fontSize: themeData.textTheme.titleLarge?.fontSize),
          ),
        ),
      ),
    );
  }
}

class MyTextWithButton extends StatelessWidget {
  final String text;
  final String buttonText;
  final void Function() onPressed;
  final EdgeInsets padding;

  const MyTextWithButton(
      {super.key,
      required this.text,
      required this.buttonText,
      required this.onPressed,
      this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
          GestureDetector(
            onTap: onPressed,
            child: Text(
              buttonText,
              style:
                  TextStyle(color: themeData.buttonTheme.colorScheme!.primary),
            ),
          )
        ],
      ),
    );
  }
}
