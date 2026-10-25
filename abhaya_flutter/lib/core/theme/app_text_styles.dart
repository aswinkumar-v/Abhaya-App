import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography styles matching Figtree and the two-tone headline signature of Abhaya
class AppTextStyles {
  static const String fontFamily = 'Figtree';

  // Headlines
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.ink,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: AppColors.ink,
    height: 1.25,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: AppColors.ink,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.4,
    color: AppColors.ink,
  );

  // Subtitle / Muted
  static const TextStyle sub = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.ink3,
    height: 1.45,
  );

  static const TextStyle eyebrow = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: AppColors.ink3,
  );

  // Body
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.ink2,
    height: 1.5,
  );

  static const TextStyle bodyBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.ink3,
  );

  static const TextStyle meta = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.ink3,
  );

  // Numbers & Stats
  static const TextStyle bigNumber = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    color: AppColors.ink,
    height: 1.0,
  );

  // Two tone headline helper
  static Widget twoToneHeadline({
    required String main,
    required String secondary,
    Color mainColor = AppColors.ink,
    Color secondaryColor = AppColors.ink3,
    double fontSize = 21,
  }) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
          height: 1.2,
          color: mainColor,
        ),
        children: [
          TextSpan(text: main),
          const TextSpan(text: '\n'),
          TextSpan(
            text: secondary,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
