import 'package:flutter/material.dart';

/// Spacing constants for consistent layout
class AppSpacing {
  AppSpacing._();

  // Base spacing unit
  static const double unit = 8.0;

  // Common spacing values
  static const double xs = 4.0;    // 0.5x
  static const double sm = 8.0;    // 1x
  static const double md = 16.0;   // 2x
  static const double lg = 24.0;   // 3x
  static const double xl = 32.0;   // 4x
  static const double xxl = 48.0;  // 6x
  static const double xxxl = 64.0; // 8x

  // Border radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusFull = 9999.0;

  // Icon sizes
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // Button heights
  static const double buttonSm = 40.0;
  static const double buttonMd = 48.0;
  static const double buttonLg = 56.0;

  // Card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardPaddingSm = EdgeInsets.all(12.0);
  static const EdgeInsets cardPaddingLg = EdgeInsets.all(24.0);

  // Screen padding
  static const EdgeInsets screenPadding = EdgeInsets.all(16.0);
  static const EdgeInsets screenPaddingH = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets screenPaddingV = EdgeInsets.symmetric(vertical: 16.0);
}

/// Shadow constants
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x1A8A2CE2),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x258A2CE2),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
  ];
}

/// Animation duration constants
class AppDurations {
  AppDurations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);
}
