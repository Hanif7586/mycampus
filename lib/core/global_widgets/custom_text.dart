// lib/core/global_widgets/custom_text.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../consts/app_colors.dart';

enum TextType {
  displayLarge,
  displayMedium,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
}

class CustomText extends StatelessWidget {
  final String text;
  final TextType type;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final double? lineHeight;
  final TextDecoration? decoration;
  final bool isGradient;
  final List<Color>? gradientColors;

  const CustomText(
    this.text, {
    super.key,
    this.type = TextType.bodyMedium,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontSize,
    this.fontWeight,
    this.letterSpacing,
    this.lineHeight,
    this.decoration,
    this.isGradient = false,
    this.gradientColors,
  });

  TextStyle _getBaseStyle() {
    switch (type) {
      case TextType.displayLarge:
        return GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: color ?? AppColors.textPrimary,
          letterSpacing: -0.5,
        );
      case TextType.displayMedium:
        return GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: color ?? AppColors.textPrimary,
        );
      case TextType.headlineLarge:
        return GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: color ?? AppColors.textPrimary,
        );
      case TextType.headlineMedium:
        return GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: color ?? AppColors.textPrimary,
        );
      case TextType.headlineSmall:
        return GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: color ?? AppColors.textPrimary,
        );
      case TextType.titleLarge:
        return GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: color ?? AppColors.textPrimary,
        );
      case TextType.titleMedium:
        return GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: color ?? AppColors.textPrimary,
        );
      case TextType.titleSmall:
        return GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: color ?? AppColors.textPrimary,
        );
      case TextType.bodyLarge:
        return GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: color ?? AppColors.textPrimary,
        );
      case TextType.bodyMedium:
        return GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: color ?? AppColors.textSecondary,
        );
      case TextType.bodySmall:
        return GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: color ?? AppColors.textSecondary,
        );
      case TextType.labelLarge:
        return GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: color ?? AppColors.textPrimary,
          letterSpacing: 0.5,
        );
      case TextType.labelMedium:
        return GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color ?? AppColors.textSecondary,
        );
      case TextType.labelSmall:
        return GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color ?? AppColors.textHint,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _getBaseStyle().copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: lineHeight,
      decoration: decoration,
      color: isGradient ? null : (color ?? _getBaseStyle().color),
    );

    if (isGradient) {
      return ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: gradientColors ?? [AppColors.primary, AppColors.accent],
        ).createShader(bounds),
        child: Text(
          text,
          style: style.copyWith(color: Colors.white),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow ?? TextOverflow.ellipsis,
        ),
      );
    }

    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
    );
  }
}
