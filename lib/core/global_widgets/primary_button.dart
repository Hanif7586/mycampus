// lib/core/global_widgets/primary_button.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../consts/app_colors.dart';

enum ButtonVariant { filled, outlined, text, gradient }

class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final double height;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final List<Color>? gradientColors;
  final double borderRadius;
  final double fontSize;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.gradient,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.height = 56,
    this.prefixIcon,
    this.suffixIcon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.gradientColors,
    this.borderRadius = 14,
    this.fontSize = 16,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.variant == ButtonVariant.outlined
                    ? AppColors.primary
                    : Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ] else ...[
          if (widget.prefixIcon != null) ...[
            widget.prefixIcon!,
            const SizedBox(width: 8),
          ],
        ],
        Text(
          widget.label,
          style: GoogleFonts.poppins(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w600,
            color: _getTextColor(),
            letterSpacing: 0.3,
          ),
        ),
        if (!widget.isLoading && widget.suffixIcon != null) ...[
          const SizedBox(width: 8),
          widget.suffixIcon!,
        ],
      ],
    );

    Widget button;
    switch (widget.variant) {
      case ButtonVariant.gradient:
        button = Container(
          height: widget.height,
          width: widget.isFullWidth ? double.infinity : widget.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradientColors ??
                  [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: widget.onPressed != null
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    )
                  ]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onPressed,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: Center(child: buttonChild),
            ),
          ),
        );
        break;

      case ButtonVariant.filled:
        button = SizedBox(
          height: widget.height,
          width: widget.isFullWidth ? double.infinity : widget.width,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.backgroundColor ?? AppColors.primary,
              foregroundColor: widget.textColor ?? Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              elevation: 0,
            ),
            child: buttonChild,
          ),
        );
        break;

      case ButtonVariant.outlined:
        button = SizedBox(
          height: widget.height,
          width: widget.isFullWidth ? double.infinity : widget.width,
          child: OutlinedButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: widget.borderColor ?? AppColors.primary,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ),
            child: buttonChild,
          ),
        );
        break;

      case ButtonVariant.text:
        button = SizedBox(
          height: widget.height,
          width: widget.isFullWidth ? double.infinity : widget.width,
          child: TextButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ),
            child: buttonChild,
          ),
        );
        break;
    }

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: button,
      ),
    );
  }

  Color _getTextColor() {
    if (widget.textColor != null) return widget.textColor!;
    switch (widget.variant) {
      case ButtonVariant.outlined:
      case ButtonVariant.text:
        return AppColors.primary;
      default:
        return Colors.white;
    }
  }
}
