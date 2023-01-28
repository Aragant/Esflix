import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.black,
  backgroundColor: Colors.black,
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(
    secondary: Colors.orange,
    brightness: Brightness.dark,
    primary: Colors.grey[100],
    onPrimary: Colors.black,
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    headline2: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    headline3: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    headline4: TextStyle(
      color: Colors.blue,
      fontSize: 12,
    ),
    headline5: TextStyle(
      color: Colors.white,
      fontSize: 12,
    ),
    headline6: TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    ),
    bodyText1: TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
    bodyText2: TextStyle(
      color: Colors.white,
      fontSize: 12,
    ),
    subtitle1: TextStyle(
      color: Colors.white,
      fontSize: 12,
    ),
    subtitle2: TextStyle(
      color: Colors.white,
      fontSize: 10,
    ),
    caption: TextStyle(
      color: Colors.white,
      fontSize: 10,
    ),
    overline: TextStyle(
      color: Colors.white,
      fontSize: 8,
    ),
  ),
);
