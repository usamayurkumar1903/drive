// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  // Dark theme palette
  static const darkBg = Color(0xFF0A0A0F);
  static const darkSurface = Color(0xFF12121A);
  static const darkCard = Color(0xFF1A1A26);
  static const darkCardElevated = Color(0xFF222232);

  // Light theme palette
  static const lightBg = Color(0xFFF5F5F7);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFFFFFFF);

  // Brand / Accent
  static const gold = Color(0xFFD4AF37);
  static const goldLight = Color(0xFFE8C96A);
  static const goldDark = Color(0xFFB8960E);

  // Semantic colors
  static const success = Color(0xFF34C759);
  static const error = Color(0xFFFF3B30);
  static const warning = Color(0xFFFF9F0A);

  // Text
  static const textPrimaryDark = Color(0xFFF0F0F5);
  static const textSecondaryDark = Color(0xFF8E8EA0);
  static const textTertiaryDark = Color(0xFF58586A);
  static const textPrimaryLight = Color(0xFF0A0A0F);
  static const textSecondaryLight = Color(0xFF4A4A5A);

  // Gradients
  static const List<Color> goldGradient = [
    Color(0xFFE8C96A),
    Color(0xFFD4AF37),
    Color(0xFFB8960E),
  ];

  static const List<Color> darkCardGradient = [
    Color(0xFF1E1E2E),
    Color(0xFF12121A),
  ];

  static const List<Color> heroGradient = [
    Colors.transparent,
    Color(0xCC0A0A0F),
  ];
}

class AppTextStyles {
  static const String fontFamily = 'Urbanist';

  static TextStyle display({Color? color, bool dark = true}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 40,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
        color: color ?? (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        height: 1.1,
      );

  static TextStyle h1({Color? color, bool dark = true}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        color: color ?? (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        height: 1.2,
      );

  static TextStyle h2({Color? color, bool dark = true}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: color ?? (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        height: 1.3,
      );

  static TextStyle h3({Color? color, bool dark = true}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: color ?? (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        height: 1.4,
      );

  static TextStyle body({Color? color, bool dark = true}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        color: color ?? (dark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
        height: 1.6,
      );

  static TextStyle bodyMedium({Color? color, bool dark = true}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: color ?? (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        height: 1.5,
      );

  static TextStyle caption({Color? color, bool dark = true}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: color ?? (dark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight),
        height: 1.4,
      );

  static TextStyle price({Color? color}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: color ?? AppColors.gold,
        height: 1.2,
      );

  static TextStyle label({Color? color, bool dark = true}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: color ?? (dark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight),
        height: 1.4,
      );
}

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    fontFamily: 'Urbanist',
    colorScheme: const ColorScheme.dark(
      primary: AppColors.gold,
      secondary: AppColors.goldLight,
      surface: AppColors.darkSurface,
      error: AppColors.error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.gold,
      unselectedItemColor: AppColors.textTertiaryDark,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
      ),
      hintStyle: AppTextStyles.body(),
    ),
    cardTheme: CardTheme(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.darkBg,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: 0.3,
        ),
        elevation: 0,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkCard,
      selectedColor: AppColors.gold.withOpacity(0.2),
      labelStyle: AppTextStyles.caption(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: BorderSide.none,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF2A2A3A),
      thickness: 1,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBg,
    fontFamily: 'Urbanist',
    colorScheme: const ColorScheme.light(
      primary: AppColors.goldDark,
      secondary: AppColors.gold,
      surface: AppColors.lightSurface,
      error: AppColors.error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
    ),
    cardTheme: CardTheme(
      color: AppColors.lightCard,
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
