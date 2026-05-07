// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  // Dark theme
  static const darkBg = Color(0xFF0F0F0F);
  static const darkSurface = Color(0xFF1A1A1A);
  static const darkCard = Color(0xFF242424);
  static const darkCardElevated = Color(0xFF2E2E2E);

  // Light theme
  static const lightBg = Color(0xFFF7F7F7);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFFFFFFF);

  // Accent - Airbnb-inspired coral/rose
  static const accent = Color(0xFFFF385C);
  static const accentLight = Color(0xFFFF6B84);
  static const accentDark = Color(0xFFE0002A);

  // Secondary accent - teal
  static const teal = Color(0xFF00A699);
  static const tealLight = Color(0xFF33C3B7);

  // Semantic
  static const success = Color(0xFF00A699);
  static const error = Color(0xFFFF385C);
  static const warning = Color(0xFFFFB400);

  // Text dark
  static const textPrimaryDark = Color(0xFFF8F8F8);
  static const textSecondaryDark = Color(0xFF9E9E9E);
  static const textTertiaryDark = Color(0xFF5E5E5E);

  // Text light
  static const textPrimaryLight = Color(0xFF222222);
  static const textSecondaryLight = Color(0xFF717171);
  static const textTertiaryLight = Color(0xFFB0B0B0);

  // Gradients
  static const List<Color> accentGradient = [
    Color(0xFFFF6B84),
    Color(0xFFFF385C),
    Color(0xFFE0002A),
  ];

  // Keep gold as alias for accent for backward compat
  static const gold = accent;
  static const goldLight = accentLight;
  static const goldDark = accentDark;
  static const List<Color> goldGradient = accentGradient;
  static const darkCardGradient = [Color(0xFF2A2A2A), Color(0xFF1A1A1A)];
  static const heroGradient = [Colors.transparent, Color(0xCC0F0F0F)];
}

class AppTextStyles {
  static const String fontFamily = 'Urbanist';

  static TextStyle display({Color? color, bool dark = true}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 38,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
        color: color ?? (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        height: 1.1,
      );

  static TextStyle h1({Color? color, bool dark = true}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 30,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: color ?? (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        height: 1.2,
      );

  static TextStyle h2({Color? color, bool dark = true}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: color ?? (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        height: 1.3,
      );

  static TextStyle h3({Color? color, bool dark = true}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
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
        letterSpacing: 0.3,
        color: color ?? (dark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
        height: 1.4,
      );

  static TextStyle price({Color? color, bool dark = true}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: color ?? (dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        height: 1.2,
      );

  static TextStyle label({Color? color, bool dark = true}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: color ?? (dark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
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
      primary: AppColors.accent,
      secondary: AppColors.teal,
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
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
      hintStyle: AppTextStyles.body(),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
        elevation: 0,
      ),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFF2A2A2A), thickness: 1),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? AppColors.accent : Colors.grey),
      trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected)
              ? AppColors.accent.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2)),
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
      primary: AppColors.accent,
      secondary: AppColors.teal,
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
    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
        elevation: 0,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? AppColors.accent : Colors.grey),
      trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected)
              ? AppColors.accent.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2)),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFFEEEEEE), thickness: 1),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
