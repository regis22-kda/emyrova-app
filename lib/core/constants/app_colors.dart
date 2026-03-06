import 'package:flutter/material.dart';

/// Emyrova color palette
class AppColors {
  AppColors._();

  // Primary brand color
  static const Color primary = Color(0xFF8A2CE2);
  static const Color primaryLight = Color(0xFFA855F7);
  static const Color primaryDark = Color(0xFF6B21A8);
  
  // Background colors
  static const Color backgroundLight = Color(0xFFF7F6F8);
  static const Color backgroundDark = Color(0xFF191121);
  
  // Surface colors
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E2E);
  
  // Text colors
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textPrimaryDark = Color(0xFFF7F6F8);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  
  // Accent colors
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentPink = Color(0xFFEC4899);
  
  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFF8A2CE2),
    Color(0xFFA855F7),
    Color(0xFFC084FC),
  ];
  
  static const List<Color> darkGradient = [
    Color(0xFF191121),
    Color(0xFF2D1B4E),
    Color(0xFF4C1D75),
  ];
  
  // Border colors
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);
  
  // Shadow colors
  static const Color shadowLight = Color(0x1A8A2CE2);
  static const Color shadowDark = Color(0x33000000);
}
