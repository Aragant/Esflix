import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.black,
  backgroundColor: Colors.black,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: Colors.orange,
    secondary: Colors.blue,
    brightness: Brightness.dark,
    inversePrimary: Colors.white,
    surface: Colors.black,
    onSurface: Colors.white,
  ),
  fontFamily: 'OpenSans',
);
