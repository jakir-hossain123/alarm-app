import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: .light,
    scaffoldBackgroundColor: Colors.white,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),


      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),

        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),

        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.w300
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),

      colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black,
    brightness: .light
  )
  );
}