import 'package:flutter/material.dart';

// const primaryColor = Colors.amber;

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Colors.teal,
    onPrimary: Colors.white,
    secondary: Colors.teal.shade300,
    onSecondary: Colors.white,
    background: Colors.grey.shade200,
    onBackground: Colors.white,
    error: Colors.red,
    onError: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
        color: Colors.black, fontSize: 17, fontWeight: FontWeight.normal),
    bodyMedium: TextStyle(
        color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
    bodySmall: TextStyle(
        color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal),
    labelLarge: TextStyle(
        color: Colors.black45, fontSize: 17, fontWeight: FontWeight.normal),
    labelMedium: TextStyle(
        color: Colors.black45, fontSize: 16, fontWeight: FontWeight.normal),
    labelSmall: TextStyle(
        color: Colors.black45, fontSize: 15, fontWeight: FontWeight.normal),
    titleLarge: TextStyle(
        color: Colors.black, fontSize: 19, fontWeight: FontWeight.w500),
    titleMedium: TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(
        color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  // colorScheme: ColorScheme(
  //   brightness: Brightness.dark,
  //   primary: Colors.teal,
  //   onPrimary: Colors.white,
  //   secondary: Colors.teal.shade300,
  //   onSecondary: Colors.white,
  //   background: Colors.grey.shade200,
  //   onBackground: Colors.white,
  //   error: Colors.red,
  //   onError: Colors.black,
  //   surface: Colors.white,
  //   onSurface: Colors.black,
  // ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
    bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
    bodySmall: TextStyle(color: Colors.white, fontSize: 14),
    labelMedium: TextStyle(color: Colors.white70, fontSize: 16),
    titleLarge: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
    titleMedium: TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
  ),
);
