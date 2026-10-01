// lib/core/global_widgets/status_badge.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../consts/app_colors.dart';

enum BadgeStatus { present, absent, late, pending, submitted, graded, cancelled, active }

class StatusBadge extends StatelessWidget {
  final BadgeStatus status;
  final String? customLabel;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.status,
    this.customLabel,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.$1.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.$1.withOpacity(0.4)),
      ),
      child: Text(
        customLabel ?? config.$2,
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: config.$1,
        ),
      ),
    );
  }

  (Color, String) _getConfig() {
    switch (status) {
      case BadgeStatus.present:
        return (AppColors.success, 'Present');
      case BadgeStatus.absent:
        return (AppColors.error, 'Absent');
      case BadgeStatus.late:
        return (AppColors.warning, 'Late');
      case BadgeStatus.pending:
        return (AppColors.warning, 'Pending');
      case BadgeStatus.submitted:
        return (AppColors.info, 'Submitted');
      case BadgeStatus.graded:
        return (AppColors.success, 'Graded');
      case BadgeStatus.cancelled:
        return (AppColors.error, 'Cancelled');
      case BadgeStatus.active:
        return (AppColors.success, 'Active');
    }
  }
}
