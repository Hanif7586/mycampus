// lib/core/consts/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Display
  static TextStyle displayLarge = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle displayMedium = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static TextStyle displaySmall = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Headline
  static TextStyle headlineLarge = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineMedium = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineSmall = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Title
  static TextStyle titleLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle titleSmall = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // Body
  static TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Label
  static TextStyle labelLarge = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static TextStyle labelMedium = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.3,
  );

  static TextStyle labelSmall = GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint,
    letterSpacing: 0.2,
  );

  // Button
  static TextStyle buttonLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static TextStyle buttonMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );

  // Special
  static TextStyle gradient = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static TextStyle appBarTitle = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
  );

  static TextStyle badge = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
    fontStyle: FontStyle.italic,
  );
}
