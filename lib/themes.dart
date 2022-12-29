import 'package:flutter/material.dart';

// const primaryColor = Colors.amber;

ThemeData lightTheme = ThemeData(
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black, fontSize: 18),
    bodyMedium: TextStyle(color: Colors.black, fontSize: 16),
    bodySmall: TextStyle(color: Colors.black, fontSize: 14),
    labelMedium: TextStyle(color: Colors.black45, fontSize: 16),
    titleLarge: TextStyle(
        color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
    titleMedium: TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(
        color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
  ),
  colorScheme: ColorScheme(
    primary: Colors.teal,
    onPrimary: Colors.white,
    secondary: Colors.blue,
    onSecondary: Colors.white,
    background: Colors.grey.shade200,
    onBackground: Colors.white,
    error: Colors.red,
    onError: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
    brightness: Brightness.light,
  ),

  // appBarTheme: AppBarTheme(backgroundColor: Colors.white, )
  // primarySwatch: primaryColor,
  // bottomNavigationBarTheme:
  //     const BottomNavigationBarThemeData(selectedItemColor: primaryColor),
  // floatingActionButtonTheme:
  //     const FloatingActionButtonThemeData(backgroundColor: primaryColor),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);
