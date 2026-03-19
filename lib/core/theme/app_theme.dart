import 'package:flutter/material.dart';

class AppTheme {
  static const Color backgroundColor = Color(0xFF48416B);
  static const Color accentColor = Color(0xFFEDC28D);
  static const Color inputBackgroundColor = Color(0xFFF2F3F5);

  static const Duration fastDuration = Duration(milliseconds: 120);
  static const Duration normalDuration = Duration(milliseconds: 240);
  static const Duration slowDuration = Duration(milliseconds: 360);

  static ThemeData get materialTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: backgroundColor,
    );
  }
}
