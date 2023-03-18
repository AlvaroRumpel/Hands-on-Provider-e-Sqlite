import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoListUiConfig {
  TodoListUiConfig._();

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.mandaliTextTheme().apply(
          bodyColor: Colors.grey,
          displayColor: Colors.grey,
          decorationColor: Colors.grey,
        ),
        primarySwatch: const MaterialColor(
          0xFF5C77CE,
          {
            50: Color(0xFFABC8F7),
            100: Color(0xFFABC8F7),
            200: Color(0xFFABC8F7),
            300: Color(0xFF5C77CE),
            400: Color(0xFF5C77CE),
            500: Color(0xFF5C77CE),
            600: Color(0xFF5C77CE),
            700: Color(0xFF5C77CE),
            800: Color(0xFF5C77CE),
            900: Color(0xFF5C77CE),
          },
        ),
        primaryColor: const Color(0xFF5C77CE),
        primaryColorLight: const Color(0xFFABC8F7),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5C77CE),
            foregroundColor: Colors.white,
          ),
        ),
      );
}
