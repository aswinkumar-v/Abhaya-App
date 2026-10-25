import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PillButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onTap;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isOutlined;

  const PillButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.height = 52,
    this.backgroundColor,
    this.textColor,
    bool isOutlined = false,
    bool? isOutline,
    bool? isPrimary,
  }) : isOutlined = isOutline ?? isOutlined;

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.teal;
    final fgColor = textColor ?? Colors.white;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 150),
        child: isOutlined
            ? OutlinedButton(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: bgColor, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height / 2)),
                  foregroundColor: bgColor,
                ),
                child: _buildChild(bgColor),
              )
            : ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: bgColor,
                  foregroundColor: fgColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height / 2)),
                  shadowColor: bgColor.withOpacity(0.3),
                ).copyWith(
                  elevation: WidgetStateProperty.resolveWith<double?>((states) {
                    if (states.contains(WidgetState.pressed)) return 0;
                    return 4;
                  }),
                ),
                child: _buildChild(fgColor),
              ),
      ),
    );
  }

  Widget _buildChild(Color color) {
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color, fontFamily: 'Figtree')),
        ],
      );
    }
    return Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color, fontFamily: 'Figtree'));
  }
}
