import 'dart:developer';

import 'package:flutter/material.dart';

class MyAuthTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final bool obscureText;
  final EdgeInsets padding;

  const MyAuthTextField(
      {super.key,
      required this.labelText,
      required this.controller,
      this.suffixIcon,
      this.obscureText = false,
      this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        keyboardType: TextInputType.name,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          // icon: Icon(Icons.person),
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          labelText: labelText,
          isDense: true,
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return '$labelText can\'t be empty';
          }
          return null;
        },
      ),
    );
  }
}

class MyPasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final EdgeInsets padding;

  const MyPasswordTextField(
      {super.key, required this.controller, this.padding = EdgeInsets.zero});

  @override
  State<MyPasswordTextField> createState() => _MyPasswordTextFieldState();
}

class _MyPasswordTextFieldState extends State<MyPasswordTextField> {
  final String labelText = "Password";

  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    Widget suffixIcon = IconButton(
      icon: Icon(
        _showPassword ? Icons.visibility : Icons.visibility_off,
        // color: Theme.of(context).primaryColorDark,
      ),
      onPressed: () {
        setState(() {
          _showPassword = !_showPassword;
        });
      },
    );

    return MyAuthTextField(
      labelText: "Password",
      controller: widget.controller,
      obscureText: !_showPassword,
      suffixIcon: suffixIcon,
      padding: widget.padding,
    );
  }
}

class MySearchTextField extends StatefulWidget {
  final TextEditingController textController;
  final void Function() onSearchButtonPressed;

  const MySearchTextField(
      {super.key,
      required this.textController,
      required this.onSearchButtonPressed});

  @override
  State<MySearchTextField> createState() => _MySearchTextFieldState();
}

class _MySearchTextFieldState extends State<MySearchTextField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      //margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      color: theme.colorScheme.surface,
      child: TextField(
          controller: widget.textController,
          style: theme.textTheme.bodyMedium,
          onSubmitted: (value) {
            widget.onSearchButtonPressed();
          },
          decoration: InputDecoration(
            // icon: Icon(Icons.person),
            suffixIcon: GestureDetector(
              onTap: widget.onSearchButtonPressed,
              child: Icon(
                Icons.search_rounded,
                size: 22,
                color: theme.colorScheme.primary,
              ),
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            hintText: "Search...",
            hintStyle: theme.textTheme.labelMedium,
            isDense: true,
          )),
    );
  }
}
