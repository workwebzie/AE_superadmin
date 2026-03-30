import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeColors {
  static const Color background = Colors.white;
  static const Color primaryBlue = Color(0xFF27374D);

  static const Color blue = Color.fromARGB(255, 92, 150, 208);
  static const Color blueLight = Color(0xFFE5F2FF);
  static const Color blueLight2 = Color(0xFFD2E9FF);
  static const Color grey = Color(0xFFD5D5D5);
  static const Color white = Colors.white;
  static const Color red = Color(0xFFC95252);
  static const Color green = Color.fromARGB(255, 82, 182, 128);
  static const Color greenLight = Color(0xFFE7FFD6);
  
  static const Color orange = Color.fromARGB(255, 226, 140, 82);
}

Map<int, Color> color = {
  50: const Color.fromRGBO(136, 14, 79, .1),
  100: const Color.fromRGBO(136, 14, 79, .2),
  200: const Color.fromRGBO(136, 14, 79, .3),
  300: const Color.fromRGBO(136, 14, 79, .4),
  400: const Color.fromRGBO(136, 14, 79, .5),
  500: const Color.fromRGBO(136, 14, 79, .6),
  600: const Color.fromRGBO(136, 14, 79, .7),
  700: const Color.fromRGBO(136, 14, 79, .8),
  800: const Color.fromRGBO(136, 14, 79, .9),
  900: const Color.fromRGBO(136, 14, 79, 1),
};

class AppTheme {
  // Adapting old aliases to new colors to maintain compatibility
  static const Color bgColor = ThemeColors.background;
  static const Color primaryColor = ThemeColors.primaryBlue;
  static const Color accentColor = ThemeColors.blue;
  static const Color cardColor = ThemeColors.white;
  static const Color textColor = ThemeColors.primaryBlue;
  static const Color fadedTextColor = Color(0xFF8B92A5);

  static const Color successColor = ThemeColors.green;
  static const Color warningColor = ThemeColors.orange;
  static const Color errorColor = ThemeColors.red;

  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: bgColor,
      primaryColor: primaryColor,
      canvasColor: cardColor,
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: textColor,
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 8,
        shadowColor: ThemeColors.primaryBlue.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: ThemeColors.grey.withOpacity(0.3), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ThemeColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ThemeColors.grey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ThemeColors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        labelStyle: TextStyle(color: fadedTextColor),
        hintStyle: TextStyle(color: fadedTextColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: cardColor,
        error: errorColor,
      ).copyWith(background: bgColor),
      dividerColor: ThemeColors.grey,
    );
  }
}
