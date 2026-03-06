import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// Emyrova theme configuration
class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: Colors.white,
        secondary: AppColors.accentPink,
        onSecondary: Colors.white,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        error: AppColors.accentRed,
        onError: Colors.white,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // Text theme using Google Fonts - Plus Jakarta Sans
      textTheme:
          GoogleFonts.plusJakartaSansTextTheme(
            const TextTheme(
              displayLarge: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
              displayMedium: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
              displaySmall: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              headlineLarge: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              headlineMedium: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              headlineSmall: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              titleSmall: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              bodyMedium: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              labelLarge: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              labelMedium: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              labelSmall: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ).apply(
            bodyColor: AppColors.textPrimaryLight,
            displayColor: AppColors.textPrimaryLight,
          ),

      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryLight,
        ),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: const BorderSide(color: AppColors.accentRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: const BorderSide(color: AppColors.accentRed, width: 2),
        ),
        hintStyle: const TextStyle(
          color: AppColors.textSecondaryLight,
          fontSize: 14,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 2,
        shadowColor: AppColors.shadowLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: AppSpacing.md,
      ),

      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        selectedColor: AppColors.primary,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
      ),

      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.borderLight,
        circularTrackColor: AppColors.borderLight,
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryDark,
        onPrimaryContainer: Colors.white,
        secondary: AppColors.accentPink,
        onSecondary: Colors.white,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        error: AppColors.accentRed,
        onError: Colors.white,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.backgroundDark,

      // Text theme
      textTheme:
          GoogleFonts.plusJakartaSansTextTheme(
            const TextTheme(
              displayLarge: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
              displayMedium: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
              displaySmall: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              headlineLarge: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              headlineMedium: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              headlineSmall: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              titleSmall: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              bodyMedium: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              labelLarge: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              labelMedium: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              labelSmall: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ).apply(
            bodyColor: AppColors.textPrimaryDark,
            displayColor: AppColors.textPrimaryDark,
          ),

      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryDark,
        ),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        hintStyle: const TextStyle(
          color: AppColors.textSecondaryDark,
          fontSize: 14,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 2,
        shadowColor: AppColors.shadowDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundDark,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
        space: AppSpacing.md,
      ),
    );
  }
}
