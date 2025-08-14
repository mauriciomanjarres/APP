import 'package:flutter/material.dart';

const Color ocre = Color(0xFFB48A28);     // Color institucional dorado
const Color aqua = Color(0xFF0097A7);     // Un azul institucional
const Color flamenco = Color(0xFFE65100); // Naranja fuerte, para botones o acentos

ThemeData appTheme = ThemeData(
  primaryColor: ocre,
  colorScheme: const ColorScheme.light(
    primary: ocre,
    secondary: flamenco,
    tertiary: aqua,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: ocre,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: flamenco,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  ),
);
