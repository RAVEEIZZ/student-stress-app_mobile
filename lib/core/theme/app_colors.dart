import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF4F39F6);
  static const Color primaryLight = Color(0xFF7B6AF8);
  static const Color primaryDark = Color(0xFF3A28C4);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientVertical = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Background & Surface
  static const Color background = Color(0xFFF8F9FE);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFEDEDF5);

  // Text
  static const Color textPrimary = Color(0xFF1E1E2D);
  static const Color textSecondary = Color(0xFF8E8EA9);
  static const Color textHint = Color(0xFFB8B8D2);

  // Stress Levels
  static const Color stressLow = Color(0xFF83C400);
  static const Color stressLowBg = Color(0xFFEFF8E0);
  static const Color stressMedium = Color(0xFFEEAA2A);
  static const Color stressMediumBg = Color(0xFFFFF5E0);
  static const Color stressHigh = Color(0xFFF14E4E);
  static const Color stressHighBg = Color(0xFFFFEBEB);

  // Misc
  static const Color shadow = Color(0x0F000000);
  static const Color divider = Color(0xFFEDEDF5);
  static const Color inputFill = Color(0xFFF5F5FA);

  /// Returns color based on stress level string
  static Color stressColor(String level) {
    switch (level.toLowerCase()) {
      case 'rendah':
        return stressLow;
      case 'sedang':
        return stressMedium;
      case 'tinggi':
        return stressHigh;
      default:
        return primary;
    }
  }

  /// Returns background color based on stress level string
  static Color stressBgColor(String level) {
    switch (level.toLowerCase()) {
      case 'rendah':
        return stressLowBg;
      case 'sedang':
        return stressMediumBg;
      case 'tinggi':
        return stressHighBg;
      default:
        return background;
    }
  }
}
