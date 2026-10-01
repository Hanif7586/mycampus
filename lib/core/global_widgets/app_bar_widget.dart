// lib/core/global_widgets/app_bar_widget.dart
import 'package:flutter/material.dart';
import '../consts/app_colors.dart';
import 'custom_text.dart';

class MyCampusAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBack;
  final bool centerTitle;
  final Color? backgroundColor;
  final Widget? bottom;
  final double bottomHeight;
  final VoidCallback? onBackPressed;

  const MyCampusAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBack = true,
    this.centerTitle = false,
    this.backgroundColor,
    this.bottom,
    this.bottomHeight = 0,
    this.onBackPressed,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + bottomHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.bgDark,
      elevation: 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: showBack
          ? GestureDetector(
              onTap: onBackPressed ?? () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textPrimary,
                  size: 18,
                ),
              ),
            )
          : leading,
      title: CustomText(
        title,
        type: TextType.titleLarge,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      actions: actions,
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(bottomHeight),
              child: bottom!,
            )
          : null,
    );
  }
}
