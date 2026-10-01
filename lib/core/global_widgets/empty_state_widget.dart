// lib/core/global_widgets/empty_state_widget.dart
import 'package:flutter/material.dart';
import '../consts/app_colors.dart';
import 'custom_text.dart';
import 'primary_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                icon,
                size: 48,
                color: iconColor ?? AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            CustomText(
              title,
              type: TextType.titleLarge,
              textAlign: TextAlign.center,
              color: AppColors.textPrimary,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              CustomText(
                subtitle!,
                type: TextType.bodyMedium,
                textAlign: TextAlign.center,
                color: AppColors.textHint,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 28),
              PrimaryButton(
                label: actionLabel!,
                onPressed: onAction,
                isFullWidth: false,
                width: 180,
                height: 48,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
