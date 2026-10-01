// lib/core/consts/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Palette
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF4A43D1);
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color accent = Color(0xFF00D4AA);
  static const Color accentLight = Color(0xFF33DDBB);

  // Background
  static const Color bgDark = Color(0xFF0D0E1A);
  static const Color bgCard = Color(0xFF161728);
  static const Color bgCardLight = Color(0xFF1E2038);
  static const Color bgSurface = Color(0xFF252640);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B3D6);
  static const Color textHint = Color(0xFF6B6E8F);
  static const Color textMuted = Color(0xFF444668);

  // Status
  static const Color success = Color(0xFF00D4AA);
  static const Color warning = Color(0xFFFFB84C);
  static const Color error = Color(0xFFFF5E7A);
  static const Color info = Color(0xFF4CA3FF);

  // Feature Colors
  static const Color noticeColor = Color(0xFF6C63FF);
  static const Color routineColor = Color(0xFF00D4AA);
  static const Color attendanceColor = Color(0xFFFF7B54);
  static const Color resultColor = Color(0xFF4CA3FF);
  static const Color assignmentColor = Color(0xFFFFB84C);
  static const Color eventColor = Color(0xFFFF5E7A);
  static const Color profileColor = Color(0xFF9D97FF);
  static const Color libraryColor = Color(0xFF3ECFAB);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF4A43D1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00D4AA), Color(0xFF00A885)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF00D4AA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFF0D0E1A), Color(0xFF121328)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E2038), Color(0xFF161728)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Attendance Chart Colors
  static const Color presentColor = Color(0xFF00D4AA);
  static const Color absentColor = Color(0xFFFF5E7A);
  static const Color lateColor = Color(0xFFFFB84C);

  // Border
  static const Color borderColor = Color(0xFF2A2D4A);
  static const Color borderLight = Color(0xFF3A3D5A);

  // Shimmer
  static const Color shimmerBase = Color(0xFF1E2038);
  static const Color shimmerHighlight = Color(0xFF2A2D4A);

  // Shadow
  static Color shadowPrimary = const Color(0xFF6C63FF).withOpacity(0.3);
  static Color shadowCard = Colors.black.withOpacity(0.3);
}
