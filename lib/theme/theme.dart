import 'package:flutter/material.dart';
import 'package:gixatapp/theme/app_color.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  /// Light Theme
  static final ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme(
      primary: AppColors.lightPrimary,
      primaryContainer: AppColors.lightPrimaryContainer,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightSurface,
      error: AppColors.lightError,
      onPrimary: AppColors.lightOnPrimary,
      onSecondary: AppColors.lightOnSecondary,
      onSurface: AppColors.lightOnSurface,
      onError: AppColors.lightOnError,
      brightness: Brightness.light,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightPrimary,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.lightOnPrimary),
      titleTextStyle: GoogleFonts.cairo(
        color: AppColors.lightOnPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.cairo(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.lightOnBackground,
      ),
      bodyLarge: GoogleFonts.cairo(
        fontSize: 16,
        color: AppColors.lightOnBackground,
      ),
      bodyMedium: GoogleFonts.cairo(
        fontSize: 14,
        color: AppColors.lightOnSurface,
      ),
      bodySmall: GoogleFonts.cairo(
        fontSize: 12,
        color: AppColors.lightOnSurface,
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.lightPrimary,
      textTheme: ButtonTextTheme.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.lightPrimary),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.lightPrimaryContainer),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  /// Dark Theme
  static final ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme(
      primary: AppColors.darkPrimary,
      primaryContainer: AppColors.darkPrimaryContainer,
      secondary: AppColors.darkSecondary,
      surface: AppColors.darkSurface,
      error: AppColors.darkError,
      onPrimary: AppColors.darkOnPrimary,
      onSecondary: AppColors.darkOnSecondary,
      onSurface: AppColors.darkOnSurface,
      onError: AppColors.darkOnError,
      brightness: Brightness.dark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkPrimary,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.darkOnPrimary),
      titleTextStyle: GoogleFonts.cairo(
        color: AppColors.darkOnPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.cairo(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.darkOnBackground,
      ),
      bodyLarge: GoogleFonts.cairo(
        fontSize: 16,
        color: AppColors.darkOnBackground,
      ),
      bodyMedium: GoogleFonts.cairo(
        fontSize: 14,
        color: AppColors.darkOnSurface,
      ),
      bodySmall: GoogleFonts.cairo(
        fontSize: 12,
        color: AppColors.darkOnSurface,
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.darkPrimary,
      textTheme: ButtonTextTheme.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.darkPrimary),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.darkPrimaryContainer),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
