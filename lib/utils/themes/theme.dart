import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homestock/utils/themes/app_colors.dart';

class AppTheme {
  AppTheme._();

  // Base Text Theme (for consistency)
  static final TextTheme baseTextTheme = TextTheme(
    headlineLarge: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.secondaryColor,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.secondaryColor,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 18,
      color: AppColors.neutralColor,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 16,
      color: AppColors.neutralVariantColor,
    ),
    labelLarge: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryColor,
    ),
  );

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.whitecolor,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      surface: Colors.white,
      error: AppColors.errorColor,
    ),
    textTheme: baseTextTheme,

    // App Bar Styling
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: baseTextTheme.headlineMedium!.copyWith(color: Colors.white),
    ),

    // Button Styling
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        textStyle: baseTextTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        side: const BorderSide(color: AppColors.primaryColor, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: baseTextTheme.labelLarge,
      ),
    ),

    // Input Field Styling
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.whitecolor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.neutralVariantColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      hintStyle: baseTextTheme.bodyMedium!.copyWith(color: AppColors.neutralVariantColor),
    ),
  );
}