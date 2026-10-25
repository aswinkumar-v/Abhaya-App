import 'package:flutter/material.dart';

/// Exact welcome stage from prototype:
/// 1. Pulsing gradient background halo (.halo.glow, 5s ease-in-out)
/// 2. Orbiting dots SVG ring (.ring, 60s linear spin, 12 colored dots)
/// 3. Fuss mascot with breathing body (4.2s), shadow scaling, glowing ear (3.2s)
/// 4. Listening soundwave (.fz-wave, 1.4s scaleY with drop shadow)
class WelcomeStage extends StatefulWidget {
  final double size;

  const WelcomeStage({
    super.key,
    this.size = 260,
  });

  @override
  State<WelcomeStage> createState() => _WelcomeStageState();
}

class _WelcomeStageState extends State<WelcomeStage>
    with TickerProviderStateMixin {
  // 1. Halo glow: 5s ease-in-out infinite (scale 1.0 -> 1.06, opacity 0.85 -> 1.0)
  late final AnimationController _haloCtrl;
  late final Animation<double> _haloScale;
  late final Animation<double> _haloOpacity;

  // 2. Spinning ring: 60s linear infinite
  late final AnimationController _spinCtrl;

  // 3. Mascot breathing: 4.2s ease-in-out infinite (body scaleX 1.0->1.025, scaleY 1.0->1.04, shadow 1.0->1.04)
  late final AnimationController _breatheCtrl;
  late final Animation<double> _bodyScaleX;
  late final Animation<double> _bodyScaleY;
  late final Animation<double> _shadowScale;

  // 4. Glowing ear: 3.2s ease-in-out infinite (opacity 0.85 -> 1.0)
  late final AnimationController _earCtrl;
  late final Animation<double> _earOpacity;

  // 5. Soundwave pulse: 1.4s ease-in-out infinite (scaleY 0.7 -> 1.1)
  late final AnimationController _waveCtrl;
  late final Animation<double> _waveScaleY;

  @override
  void initState() {
    super.initState();

    // 1. Halo Glow
    _haloCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    _haloScale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _haloCtrl, curve: Curves.easeInOut),
    );
    _haloOpacity = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _haloCtrl, curve: Curves.easeInOut),
    );

    // 2. Spinning Ring
    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    // 3. Mascot Breathing & Shadow
    _breatheCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2100),
    )..repeat(reverse: true);
    _bodyScaleX = Tween<double>(begin: 1.0, end: 1.025).animate(
      CurvedAnimation(parent: _breatheCtrl, curve: Curves.easeInOut),
    );
    _bodyScaleY = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _breatheCtrl, curve: Curves.easeInOut),
    );
    _shadowScale = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _breatheCtrl, curve: Curves.easeInOut),
    );

    // 4. Glowing Ear
    _earCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _earOpacity = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _earCtrl, curve: Curves.easeInOut),
    );

    // 5. Soundwave
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _waveScaleY = Tween<double>(begin: 0.7, end: 1.1).animate(
      CurvedAnimation(parent: _waveCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _haloCtrl.dispose();
    _spinCtrl.dispose();
    _breatheCtrl.dispose();
    _earCtrl.dispose();
    _waveCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.of(context).disableAnimations;
    final scale = widget.size / 260.0;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // ── 1. Pulsing Gradient Background Halo (.halo.glow) ─────
          if (reduced)
            _buildHalo(scale: 1.0, opacity: 0.85)
          else
            AnimatedBuilder(
              animation: _haloCtrl,
              builder: (context, _) => _buildHalo(
                scale: _haloScale.value,
                opacity: _haloOpacity.value,
              ),
            ),

          // ── 2. Spinning 12-Dot Constellation Ring (.ring) ────────
          if (reduced)
            CustomPaint(
              size: Size(250 * scale, 250 * scale),
              painter: const _RingDotsPainter(),
            )
          else
            RotationTransition(
              turns: _spinCtrl,
              child: CustomPaint(
                size: Size(250 * scale, 250 * scale),
                painter: const _RingDotsPainter(),
              ),
            ),

          // ── 3. Mascot Container (200x200 viewBox) ────────────────
          SizedBox(
            width: 200 * scale,
            height: 200 * scale,
            child: AnimatedBuilder(
              animation: Listenable.merge(
                reduced ? [] : [_breatheCtrl, _earCtrl, _waveCtrl],
              ),
              builder: (context, _) {
                final sx = reduced ? 1.0 : _bodyScaleX.value;
                final sy = reduced ? 1.0 : _bodyScaleY.value;
                final shSc = reduced ? 1.0 : _shadowScale.value;
                final earOp = reduced ? 0.95 : _earOpacity.value;
                final waveSc = reduced ? 1.0 : _waveScaleY.value;

                return CustomPaint(
                  size: Size(200 * scale, 200 * scale),
                  painter: _FussWelcomePainter(
                    bodyScaleX: sx,
                    bodyScaleY: sy,
                    shadowScale: shSc,
                    earOpacity: earOp,
                    waveScaleY: waveSc,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHalo({required double scale, required double opacity}) {
    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: Alignment(-0.24, -0.36), // circle at 38% 32%
              radius: 0.76, // 76%
              colors: [
                Color(0xF2FFFFFF), // rgba(255, 255, 255, 0.95) 0%
                Color(0xE6D5EFE6), // rgba(213, 239, 230, 0.9) 30%
                Color(0x8CF2C7AE), // rgba(242, 199, 174, 0.55) 62%
                Color(0x00C8C6F0), // rgba(200, 198, 240, 0) 76%
              ],
              stops: [0.0, 0.30, 0.62, 0.76],
            ),
          ),
        ),
      ),
    );
  }
}

// ── 12 Colored Dots Ring Painter ───────────────────────────────────────────
class _RingDotsPainter extends CustomPainter {
  const _RingDotsPainter();

  // Exact 12 dots from HTML SVG in 250×250 viewBox
  static const _dots = [
    [125.0, 8.0, 5.0, 0xFFF2B7A1],
    [183.0, 24.0, 4.0, 0xFFB9E0D7],
    [226.0, 67.0, 5.5, 0xFFC9C8F2],
    [242.0, 125.0, 4.0, 0xFFF5D985],
    [226.0, 183.0, 5.0, 0xFFB9E0D7],
    [183.0, 226.0, 4.0, 0xFFF2B7A1],
    [125.0, 242.0, 5.5, 0xFFC9C8F2],
    [67.0, 226.0, 4.0, 0xFFF5D985],
    [24.0, 183.0, 5.0, 0xFFF2B7A1],
    [8.0, 125.0, 4.0, 0xFFB9E0D7],
    [24.0, 67.0, 5.5, 0xFFF5D985],
    [67.0, 24.0, 4.0, 0xFFC9C8F2],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 250.0;

    for (final d in _dots) {
      final cx = (d[0] as double) * s;
      final cy = (d[1] as double) * s;
      final r = (d[2] as double) * s;
      final color = Color(d[3] as int);

      canvas.drawCircle(Offset(cx, cy), r, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _RingDotsPainter oldDelegate) => false;
}

// ── Complete Mascot Painter with Body Breathing, Ear Glow & Soundwaves ──────
class _FussWelcomePainter extends CustomPainter {
  final double bodyScaleX;
  final double bodyScaleY;
  final double shadowScale;
  final double earOpacity;
  final double waveScaleY;

  const _FussWelcomePainter({
    required this.bodyScaleX,
    required this.bodyScaleY,
    required this.shadowScale,
    required this.earOpacity,
    required this.waveScaleY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 200.0;

    // ── 1. Shadow (.fz-shadow: cx=104, cy=188, rx=66, ry=7, #9C92D6 .28) ───
    canvas.save();
    // transform-origin: center (104, 188)
    canvas.translate(104 * s, 188 * s);
    canvas.scale(shadowScale);
    canvas.translate(-104 * s, -188 * s);

    final shadowPaint = Paint()
      ..color = const Color(0xFF9C92D6).withValues(alpha: 0.28);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(104 * s, 188 * s),
        width: 132 * s,
        height: 14 * s,
      ),
      shadowPaint,
    );
    canvas.restore();

    // ── 2. Body Parts (.fz-body: transform-origin: 50% 100% -> (104, 188)) ──
    canvas.save();
    canvas.translate(104 * s, 188 * s);
    canvas.scale(bodyScaleX, bodyScaleY);
    canvas.translate(-104 * s, -188 * s);

    // Gradients
    final fz7B = RadialGradient(
      center: const Alignment(-0.2, -0.5),
      radius: 0.85,
      colors: const [
        Color(0xFFFFFFFF),
        Color(0xFFF1EEFA),
        Color(0xFFD9D3F1),
        Color(0xFFBDB3E6),
      ],
      stops: const [0.0, 0.38, 0.72, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final fz7F = RadialGradient(
      center: const Alignment(-0.1, -0.4),
      radius: 0.75,
      colors: const [
        Color(0xFFFFFFFF),
        Color(0xFFE6E1F6),
        Color(0xFFC3B9EA),
      ],
      stops: const [0.0, 0.55, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final fz7E = RadialGradient(
      colors: [
        const Color(0xFFFFAE9C).withValues(alpha: (0.95 * earOpacity).clamp(0.0, 1.0)),
        const Color(0xFFFFC2B4).withValues(alpha: (0.45 * earOpacity).clamp(0.0, 1.0)),
        const Color(0xFFFFC2B4).withValues(alpha: 0.0),
      ],
      stops: const [0.0, 0.60, 1.0],
    ).createShader(Rect.fromCircle(center: Offset(56 * s, 92 * s), radius: 34 * s));

    final fz7T = RadialGradient(
      colors: [
        const Color(0xFF8FDDEB).withValues(alpha: 0.55),
        const Color(0xFF8FDDEB).withValues(alpha: 0.0),
      ],
    ).createShader(Rect.fromCircle(center: Offset(60 * s, 122 * s), radius: 50 * s));

    final fz7C = RadialGradient(
      colors: [
        const Color(0xFFFF9EA8).withValues(alpha: 0.55),
        const Color(0xFFFF9EA8).withValues(alpha: 0.0),
      ],
    ).createShader(Rect.fromCircle(center: Offset(118 * s, 116 * s), radius: 14 * s));

    final bodyPaintB = Paint()..shader = fz7B;
    final bodyPaintF = Paint()..shader = fz7F;
    final cyanPaint = Paint()..shader = fz7T;
    final earPaint = Paint()..shader = fz7E;
    final cheekPaint = Paint()..shader = fz7C;

    // Body ellipses from HTML
    canvas.drawOval(
      Rect.fromCenter(center: Offset(150 * s, 160 * s), width: 54 * s, height: 46 * s),
      bodyPaintF,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(104 * s, 142 * s), width: 112 * s, height: 84 * s),
      bodyPaintB,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(104 * s, 86 * s), width: 136 * s, height: 128 * s),
      bodyPaintB,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(60 * s, 122 * s), width: 88 * s, height: 100 * s),
      cyanPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(58 * s, 150 * s), width: 40 * s, height: 48 * s),
      bodyPaintF,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(96 * s, 166 * s), width: 58 * s, height: 46 * s),
      bodyPaintF,
    );

    // Glowing warm ear (.fz-ear: cx=56, cy=92, r=34)
    canvas.drawCircle(Offset(56 * s, 92 * s), 34 * s, earPaint);

    // Cheeks (.fz-cheek)
    canvas.drawCircle(Offset(118 * s, 116 * s), 12 * s, cheekPaint);
    canvas.drawCircle(Offset(162 * s, 113 * s), 10 * s, cheekPaint);

    // Calm Face Expression (.fz-f.calm: stroke="#2B2547", stroke-width="2.6")
    final faceStroke = Paint()
      ..color = const Color(0xFF2B2547)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Eye 1: M110 100q8 7 16 0
    final eye1 = Path()
      ..moveTo(110 * s, 100 * s)
      ..quadraticBezierTo(118 * s, 107 * s, 126 * s, 100 * s);
    // Eye 2: M150 98q7 6 13 0
    final eye2 = Path()
      ..moveTo(150 * s, 98 * s)
      ..quadraticBezierTo(157 * s, 104 * s, 163 * s, 98 * s);
    // Gentle smile: M133 115q4 3 8 0
    final mouth = Path()
      ..moveTo(133 * s, 115 * s)
      ..quadraticBezierTo(137 * s, 118 * s, 141 * s, 115 * s);

    canvas.drawPath(eye1, faceStroke);
    canvas.drawPath(eye2, faceStroke);
    canvas.drawPath(mouth, faceStroke);

    canvas.restore(); // end of fz-body

    // ── 4. Soundwave Lines (.fz-wave: 1.4s scaleY with drop shadow) ────────
    canvas.save();
    // transform-origin: 50% 50% of the wave bbox (x: 18..60, y: 72..116 -> center (39, 94))
    canvas.translate(39 * s, 94 * s);
    canvas.scale(1.0, waveScaleY);
    canvas.translate(-39 * s, -94 * s);

    // Drop shadow: drop-shadow(0 0 3px rgba(255, 190, 170, 0.9))
    final shadowWavePaint = Paint()
      ..color = const Color(0xFFFFBEAA).withValues(alpha: 0.90)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.6 * s
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);

    final wavePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6 * s
      ..strokeCap = StrokeCap.round;

    const bars = [
      [18.0, 92.0, 4.0],
      [24.0, 89.0, 10.0],
      [30.0, 84.0, 20.0],
      [36.0, 78.0, 32.0],
      [42.0, 72.0, 44.0],
      [48.0, 80.0, 28.0],
      [54.0, 86.0, 16.0],
      [60.0, 90.0, 8.0],
    ];

    // Draw shadow first, then crisp white stroke
    for (final b in bars) {
      final x = b[0] * s;
      final y1 = b[1] * s;
      final y2 = (b[1] + b[2]) * s;
      canvas.drawLine(Offset(x, y1), Offset(x, y2), shadowWavePaint);
      canvas.drawLine(Offset(x, y1), Offset(x, y2), wavePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FussWelcomePainter oldDelegate) =>
      oldDelegate.bodyScaleX != bodyScaleX ||
      oldDelegate.bodyScaleY != bodyScaleY ||
      oldDelegate.shadowScale != shadowScale ||
      oldDelegate.earOpacity != earOpacity ||
      oldDelegate.waveScaleY != waveScaleY;
}
