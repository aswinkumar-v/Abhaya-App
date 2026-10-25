import 'dart:math' as math;
import 'package:flutter/material.dart';

enum FussMood { happy, calm, thinking, great, stressed, tired, okay, sad }

/// Authentic Fuss mascot - the cute cloud companion in Abhaya
class FussAvatar extends StatelessWidget {
  final double size;
  final FussMood mood;
  final bool showHalo;
  final bool showSoundWaves;
  final Color? soundWaveColor;
  /// 0.0 to 1.0 driving 3.6s soundwave pulse (@keyframes zz)
  final double? soundWaveProgress;
  /// 0.0 = eyes fully open, 1.0 = eyes fully closed (blink)
  final double blinkAmount;
  /// Optional direct eye closed ratio: 0.0 = open eyes, 1.0 = calm closed eyes
  final double? eyeClosedAmount;

  const FussAvatar({
    super.key,
    this.size = 64,
    this.mood = FussMood.happy,
    this.showHalo = false,
    this.showSoundWaves = false,
    this.soundWaveColor,
    this.soundWaveProgress,
    this.blinkAmount = 0.0,
    this.eyeClosedAmount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          if (showHalo)
            Container(
              width: size * 1.25,
              height: size * 1.25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF7EE0C4).withValues(alpha: 0.4),
                    const Color(0xFF7EE0C4).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          CustomPaint(
            size: Size(size, size),
            painter: _FussPainter(
              mood: mood,
              showSoundWaves: showSoundWaves,
              soundWaveColor: soundWaveColor,
              soundWaveProgress: soundWaveProgress,
              blinkAmount: blinkAmount,
              eyeClosedAmount: eyeClosedAmount,
            ),
          ),
        ],
      ),
    );
  }
}

class _FussPainter extends CustomPainter {
  final FussMood mood;
  final bool showSoundWaves;
  final Color? soundWaveColor;
  final double? soundWaveProgress;
  final double blinkAmount; // 0=open → 1=closed
  final double? eyeClosedAmount;

  _FussPainter({
    required this.mood,
    this.showSoundWaves = false,
    this.soundWaveColor,
    this.soundWaveProgress,
    this.blinkAmount = 0.0,
    this.eyeClosedAmount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 200.0; // scale factor based on 200x200 SVG

    // Shadow at the bottom
    final shadowPaint = Paint()..color = const Color(0xFF9C92D6).withValues(alpha: 0.25);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(104 * s, 186 * s), width: 132 * s, height: 16 * s),
      shadowPaint,
    );

    // Body gradients
    final bodyShader = RadialGradient(
      center: const Alignment(-0.2, -0.5),
      radius: 0.9,
      colors: const [
        Color(0xFFFFFFFF),
        Color(0xFFF1EEFA),
        Color(0xFFD9D3F1),
        Color(0xFFBDB3E6),
      ],
      stops: const [0.0, 0.4, 0.75, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final bodyPaint = Paint()..shader = bodyShader;

    final puffShader = RadialGradient(
      center: const Alignment(-0.1, -0.4),
      radius: 0.75,
      colors: const [
        Color(0xFFFFFFFF),
        Color(0xFFE6E1F6),
        Color(0xFFC3B9EA),
      ],
      stops: const [0.0, 0.55, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final puffPaint = Paint()..shader = puffShader;

    // Cyan tint puff on left
    final cyanPuffShader = RadialGradient(
      colors: [
        const Color(0xFF8FDDEB).withValues(alpha: 0.55),
        const Color(0xFF8FDDEB).withValues(alpha: 0.0),
      ],
    ).createShader(Rect.fromCircle(center: Offset(60 * s, 122 * s), radius: 50 * s));
    final cyanPaint = Paint()..shader = cyanPuffShader;

    // Pink ear puff on left
    final earShader = RadialGradient(
      colors: [
        const Color(0xFFFFAE9C).withValues(alpha: 0.75),
        const Color(0xFFFFC2B4).withValues(alpha: 0.0),
      ],
    ).createShader(Rect.fromCircle(center: Offset(56 * s, 92 * s), radius: 34 * s));
    final earPaint = Paint()..shader = earShader;

    // Draw cloud puffs:
    // Puffs bottom right
    canvas.drawOval(Rect.fromCenter(center: Offset(150 * s, 156 * s), width: 54 * s, height: 46 * s), puffPaint);
    // Lower body
    canvas.drawOval(Rect.fromCenter(center: Offset(104 * s, 140 * s), width: 116 * s, height: 86 * s), bodyPaint);
    // Upper main head
    canvas.drawOval(Rect.fromCenter(center: Offset(104 * s, 86 * s), width: 136 * s, height: 128 * s), bodyPaint);
    // Cyan soft glow puff
    canvas.drawOval(Rect.fromCenter(center: Offset(60 * s, 122 * s), width: 88 * s, height: 100 * s), cyanPaint);
    // Left bottom puffs
    canvas.drawOval(Rect.fromCenter(center: Offset(58 * s, 148 * s), width: 42 * s, height: 48 * s), puffPaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(96 * s, 164 * s), width: 60 * s, height: 48 * s), puffPaint);
    // Ear glow
    canvas.drawCircle(Offset(56 * s, 92 * s), 34 * s, earPaint);

    // Cheeks - rosy pink radial gradients
    final cheekShader1 = RadialGradient(
      colors: [
        const Color(0xFFFF8EA0).withValues(alpha: 0.8),
        const Color(0xFFFF8EA0).withValues(alpha: 0.0),
      ],
    ).createShader(Rect.fromCircle(center: Offset(116 * s, 116 * s), radius: 14 * s));
    canvas.drawCircle(Offset(116 * s, 116 * s), 14 * s, Paint()..shader = cheekShader1);

    final cheekShader2 = RadialGradient(
      colors: [
        const Color(0xFFFF8EA0).withValues(alpha: 0.8),
        const Color(0xFFFF8EA0).withValues(alpha: 0.0),
      ],
    ).createShader(Rect.fromCircle(center: Offset(164 * s, 113 * s), radius: 12 * s));
    canvas.drawCircle(Offset(164 * s, 113 * s), 12 * s, Paint()..shader = cheekShader2);

    // Facial expressions
    final faceStroke = Paint()
      ..color = const Color(0xFF2B2547)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final dotPaint = Paint()..color = const Color(0xFF2B2547);

    if (eyeClosedAmount != null) {
      final c = eyeClosedAmount!.clamp(0.0, 1.0);
      // c = 0.0 -> open smiling eyes (^ ^)
      // c = 1.0 -> calm sleeping arcs (⌒ ⌒)
      final e1cy = (92.0 * (1 - c) + 107.0 * c) * s;
      final e2cy = (91.0 * (1 - c) + 105.0 * c) * s;
      final eye1 = Path()
        ..moveTo(109 * s, 100 * s)
        ..quadraticBezierTo(117 * s, e1cy, 125 * s, 100 * s);
      final eye2 = Path()
        ..moveTo(149 * s, 98 * s)
        ..quadraticBezierTo(156 * s, e2cy, 163 * s, 98 * s);
      canvas.drawPath(eye1, faceStroke);
      canvas.drawPath(eye2, faceStroke);

      final mouthCy = (122.0 * (1 - c) + 118.0 * c) * s;
      final mouth = Path()
        ..moveTo(132 * s, 114 * s)
        ..quadraticBezierTo(137 * s, mouthCy, 142 * s, 114 * s);
      canvas.drawPath(mouth, faceStroke);
    } else if (mood == FussMood.happy || mood == FussMood.great) {
      // Happy curving eyes: ^ ^ — lerp toward closed line on blink
      final blink = blinkAmount;
      // Eye 1: arc control point lerps from (116,92)→(116,103) when blinking
      final e1cy = (92 * (1 - blink) + 103 * blink) * s;
      final e2cy = (91 * (1 - blink) + 101 * blink) * s;
      final eye1 = Path()
        ..moveTo(108 * s, 103 * s)
        ..quadraticBezierTo(116 * s, e1cy, 124 * s, 103 * s);
      final eye2 = Path()
        ..moveTo(148 * s, 101 * s)
        ..quadraticBezierTo(155 * s, e2cy, 162 * s, 101 * s);
      canvas.drawPath(eye1, faceStroke);
      canvas.drawPath(eye2, faceStroke);

      // Cute open smile
      final mouth = Path()
        ..moveTo(131 * s, 112 * s)
        ..quadraticBezierTo(137 * s, 122 * s, 143 * s, 112 * s);
      canvas.drawPath(mouth, faceStroke);
    } else if (mood == FussMood.calm) {
      // Calm happy sleeping arcs: ⌒ ⌒ (as shown for "Good" in prototype)
      final eye1 = Path()
        ..moveTo(109 * s, 100 * s)
        ..quadraticBezierTo(117 * s, 107 * s, 125 * s, 100 * s);
      final eye2 = Path()
        ..moveTo(149 * s, 98 * s)
        ..quadraticBezierTo(156 * s, 105 * s, 163 * s, 98 * s);
      canvas.drawPath(eye1, faceStroke);
      canvas.drawPath(eye2, faceStroke);

      // Gentle smile
      final mouth = Path()
        ..moveTo(133 * s, 115 * s)
        ..quadraticBezierTo(137 * s, 118 * s, 141 * s, 115 * s);
      canvas.drawPath(mouth, faceStroke);
    } else if (mood == FussMood.okay || mood == FussMood.thinking) {
      // Two dots for eyes
      canvas.drawCircle(Offset(118 * s, 100 * s), 3.2 * s, dotPaint);
      canvas.drawCircle(Offset(156 * s, 98 * s), 3.0 * s, dotPaint);
      // Straight line mouth
      canvas.drawLine(Offset(133 * s, 116 * s), Offset(142 * s, 116 * s), faceStroke);
    } else if (mood == FussMood.stressed) {
      // Stressed zigzag eyes: > <
      final eye1 = Path()
        ..moveTo(112 * s, 96 * s)
        ..lineTo(122 * s, 101 * s)
        ..lineTo(112 * s, 106 * s);
      final eye2 = Path()
        ..moveTo(161 * s, 94 * s)
        ..lineTo(151 * s, 99 * s)
        ..lineTo(161 * s, 104 * s);
      canvas.drawPath(eye1, faceStroke);
      canvas.drawPath(eye2, faceStroke);

      // Wavy zigzag mouth
      final mouth = Path()
        ..moveTo(129 * s, 118 * s)
        ..quadraticBezierTo(131.5 * s, 115 * s, 134 * s, 118 * s)
        ..quadraticBezierTo(136.5 * s, 121 * s, 139 * s, 118 * s)
        ..quadraticBezierTo(141.5 * s, 115 * s, 144 * s, 118 * s);
      canvas.drawPath(mouth, faceStroke);

      // Sweat drop
      final sweatPaint = Paint()..color = const Color(0xFF8FC9F0);
      final sweat = Path()
        ..moveTo(178 * s, 76 * s)
        ..quadraticBezierTo(174 * s, 83 * s, 178 * s, 85 * s)
        ..quadraticBezierTo(182 * s, 83 * s, 178 * s, 76 * s);
      canvas.drawPath(sweat, sweatPaint);
    } else if (mood == FussMood.tired) {
      // Peaceful resting horizontal eyelids: M110 102h15, M150 100h13
      canvas.drawLine(Offset(110 * s, 102 * s), Offset(125 * s, 102 * s), faceStroke);
      canvas.drawLine(Offset(150 * s, 100 * s), Offset(163 * s, 100 * s), faceStroke);

      // Gentle sleepy mouth: M134 117q3 2 6 0
      final mouth = Path()
        ..moveTo(134 * s, 117 * s)
        ..quadraticBezierTo(137 * s, 119 * s, 140 * s, 117 * s);
      canvas.drawPath(mouth, faceStroke);
    } else if (mood == FussMood.sad) {
      // Sad eyebrows
      final brow1 = Path()..moveTo(110 * s, 93 * s)..lineTo(122 * s, 89 * s);
      final brow2 = Path()..moveTo(163 * s, 91 * s)..lineTo(152 * s, 87 * s);
      canvas.drawPath(brow1, faceStroke);
      canvas.drawPath(brow2, faceStroke);

      // Eye dots
      canvas.drawCircle(Offset(118 * s, 101 * s), 3.2 * s, dotPaint);
      canvas.drawCircle(Offset(156 * s, 99 * s), 3.0 * s, dotPaint);

      // Downturned mouth
      final mouth = Path()
        ..moveTo(132 * s, 121 * s)
        ..quadraticBezierTo(137 * s, 116 * s, 143 * s, 121 * s);
      canvas.drawPath(mouth, faceStroke);

      // Tear drop
      final tearPaint = Paint()..color = const Color(0xFF8FC9F0);
      final tear = Path()
        ..moveTo(118 * s, 108 * s)
        ..quadraticBezierTo(114 * s, 115 * s, 118 * s, 117 * s)
        ..quadraticBezierTo(122 * s, 115 * s, 118 * s, 108 * s);
      canvas.drawPath(tear, tearPaint);
    }

    if (showSoundWaves) {
      // 8 soundwave bars on the left side of Fuss:
      // M18 92v4, M24 89v10, M30 84v20, M36 78v32, M42 72v44, M48 80v28, M54 86v16, M60 90v8
      const waveBars = [
        [18.0, 92.0, 4.0],
        [24.0, 89.0, 10.0],
        [30.0, 84.0, 20.0],
        [36.0, 78.0, 32.0],
        [42.0, 72.0, 44.0],
        [48.0, 80.0, 28.0],
        [54.0, 86.0, 16.0],
        [60.0, 90.0, 8.0],
      ];

      final baseColor = soundWaveColor ?? const Color(0xFFE27B5E);

      for (int i = 0; i < waveBars.length; i++) {
        final bx = waveBars[i][0] * s;
        final by = waveBars[i][1] * s;
        final bl = waveBars[i][2] * s;

        double dy = 0.0;
        double op = 0.85;

        if (soundWaveProgress != null) {
          // Keyframes .zz (3.6s ease-in-out infinite):
          // 0%, 100%: opacity .3, translateY(2px)
          // 50%:      opacity .9, translateY(-3px)
          final barPhase = (soundWaveProgress! + i * 0.09) % 1.0;
          final waveVal = 0.5 - 0.5 * math.cos(barPhase * 2 * math.pi);
          op = 0.3 + 0.6 * waveVal;
          dy = (2.0 - 5.0 * waveVal) * s;
        }

        final p = Paint()
          ..color = baseColor.withValues(alpha: op.clamp(0.0, 1.0))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.6 * s
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(Offset(bx, by + dy), Offset(bx, by + bl + dy), p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FussPainter oldDelegate) =>
      oldDelegate.mood != mood ||
      oldDelegate.showSoundWaves != showSoundWaves ||
      oldDelegate.soundWaveColor != soundWaveColor ||
      oldDelegate.soundWaveProgress != soundWaveProgress ||
      oldDelegate.blinkAmount != blinkAmount ||
      oldDelegate.eyeClosedAmount != eyeClosedAmount;
}
