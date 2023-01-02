import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double padding;
  const Logo({super.key, this.padding = 64});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: Column(
        children: [
          Text(
            "Ritter",
            style:
                TextStyle(color: themeData.colorScheme.primary, fontSize: 50),
          ),
          Text(
            "Microblog",
            style:
                TextStyle(color: themeData.colorScheme.primary, fontSize: 26),
          )
        ],
      ),
    );
  }
}
