import 'package:flutter/material.dart';
import 'package:flutter_caculator/theme/my_app_color.dart';

class MyAppTheme {
  static ThemeData lightTheme = ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
      scaffoldBackgroundColor: MyAppColors.backgroundLightColor);
  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
  );
}
