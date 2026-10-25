import 'package:flutter/material.dart';

/// Abhaya App Color Palette directly translated from abhaya.css
class AppColors {
  // Brand & Inks
  static const Color ink = Color(0xFF12302E);
  static const Color ink2 = Color(0xFF4B6462);
  static const Color ink3 = Color(0xFF7E9592);
  static const Color mute = Color(0xFF9DB0AD);

  // Teals & Dark Greens
  static const Color teal = Color(0xFF1E6B63);
  static const Color teal2 = Color(0xFF2A8077);
  static const Color deep = Color(0xFF12292A);
  static const Color deep2 = Color(0xFF1C3A3A);

  // Mint Tones
  static const Color mint = Color(0xFFD7EEE8);
  static const Color mint2 = Color(0xFFEAF5F1);
  static const Color mintx = Color(0xFFBFE3D9);

  // Neutral & Surfaces
  static const Color cream = Color(0xFFF3F1EC);
  static const Color line = Color(0xFFE6ECEA);
  static const Color card = Color(0xFFFFFFFF);
  static const Color track = Color(0xFFEEF1EF);
  static const Color bg = Color(0xFFF4F7F6);

  // Pastels & Accent Colors
  static const Color blush = Color(0xFFFBE3D7);
  static const Color blushInk = Color(0xFFB0573F);
  static const Color lilac = Color(0xFFE7E3F6);
  static const Color lilacInk = Color(0xFF5D4E9A);
  static const Color sand = Color(0xFFFBEFC9);
  static const Color sandInk = Color(0xFF8A6A12);
  static const Color sky = Color(0xFFDCEBF1);
  static const Color skyInk = Color(0xFF2D6383);
  static const Color sage = Color(0xFFDDEFE6);
  static const Color sageInk = Color(0xFF2F6B52);

  // Status & Highlights
  static const Color yellow = Color(0xFFF5D985);
  static const Color salmon = Color(0xFFF2B7A1);
  static const Color aqua = Color(0xFFB9E0D7);
  static const Color ok = Color(0xFF1E8A6C);
  static const Color okBg = Color(0xFFE1F3EC);
  static const Color bad = Color(0xFFB4533D);
  static const Color badBg = Color(0xFFFBE8E1);

  // Gradients
  static const LinearGradient darkHeaderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF123832),
      Color(0xFF16463F),
      Color(0xFF1A5249),
    ],
  );

  static const LinearGradient mintCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE4F4EF), Color(0xFFC8E8DE)],
  );

  static const LinearGradient blushCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFDEDE4), Color(0xFFF6D3C2)],
  );

  static const LinearGradient skyCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE6F1F6), Color(0xFFCBE1EC)],
  );

  static const LinearGradient lilacCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEFEDFB), Color(0xFFDAD4F4)],
  );

  static const RadialGradient tutorOrbGradient = RadialGradient(
    center: Alignment(-0.4, -0.4),
    radius: 0.8,
    colors: [
      Color(0xFFF3B07F),
      Color(0xFFF5C4A4),
      Color(0xFFC9C8F2),
      Color(0xFF9DB5F2),
    ],
  );
}
