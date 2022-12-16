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
        color: Theme.of(context).primaryColorDark,
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
