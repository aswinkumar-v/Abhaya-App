import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StatTile extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;

  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: iconColor ?? AppColors.teal),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.ink3,
          ),
        ),
      ],
    );
  }
}

class PillButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isPrimary;
  final bool isOutline;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;

  const PillButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.isPrimary = true,
    this.isOutline = false,
    this.backgroundColor,
    this.textColor,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = backgroundColor ??
        (isPrimary
            ? AppColors.teal
            : isOutline
                ? Colors.transparent
                : Colors.white);
    Color fg = textColor ??
        (isPrimary
            ? Colors.white
            : isOutline
                ? AppColors.ink
                : AppColors.ink);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(height / 2),
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(height / 2),
          border: isOutline ? Border.all(color: AppColors.line) : null,
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: AppColors.teal.withOpacity(0.24),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: fg),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
