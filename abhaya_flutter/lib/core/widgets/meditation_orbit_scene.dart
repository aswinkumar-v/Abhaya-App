import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'fuss_avatar.dart';

/// Meditation art scene for Calm Audio:
/// - Dynamic radial gradient backdrop
/// - Orbiting constellation dots around the mascot
/// - Ambient glow halo
/// - Fuss mascot with CSS keyframe-driven soundwaves (.zz) and gentle floating
class MeditationOrbitScene extends StatefulWidget {
  final List<Color> gradientColors;
  final bool isPlaying;
  final double height;

  const MeditationOrbitScene({
    super.key,
    required this.gradientColors,
    this.isPlaying = true,
    this.height = 180,
  });

  @override
  State<MeditationOrbitScene> createState() => _MeditationOrbitSceneState();
}

class _MeditationOrbitSceneState extends State<MeditationOrbitScene>
    with TickerProviderStateMixin {
  // 1. Orbit controller (continuous slow rotation)
  late final AnimationController _orbitCtrl;

  // 2. Soundwave controller (3.6s cycle matching CSS @keyframes zz)
  late final AnimationController _waveCtrl;

  // 3. Float controller (4.0s gentle vertical drift)
  late final AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();

    _orbitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    );

    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    if (widget.isPlaying) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    _orbitCtrl.repeat();
    _waveCtrl.repeat();
    _floatCtrl.repeat(reverse: true);
  }

  void _stopAnimations() {
    _orbitCtrl.stop();
    _waveCtrl.stop();
    _floatCtrl.stop();
  }

  @override
  void didUpdateWidget(covariant MeditationOrbitScene oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _startAnimations();
      } else {
        _stopAnimations();
      }
    }
  }

  @override
  void dispose() {
    _orbitCtrl.dispose();
    _waveCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.gradientColors,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Radial bottom light highlight ────────────────────────
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, 1.2),
                  radius: 0.7,
                  colors: [
                    Colors.white.withValues(alpha: 0.38),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // ── Orbiting Constellation Dots & subtle ring ─────────────
          AnimatedBuilder(
            animation: _orbitCtrl,
            builder: (context, _) {
              final angle = _orbitCtrl.value * 2 * math.pi;
              return CustomPaint(
                size: Size(widget.height * 1.5, widget.height),
                painter: _OrbitingDotsPainter(angle: angle),
              );
            },
          ),

          // ── Central Soft Halo ─────────────────────────────────────
          Container(
            width: 124,
            height: 124,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.30),
                  Colors.white.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),

          // ── Floating Fuss mascot + Soundwaves (.zz) ───────────────
          AnimatedBuilder(
            animation: Listenable.merge([_floatCtrl, _waveCtrl]),
            builder: (context, _) {
              // ±3.5 px gentle float
              final floatY = math.sin(_floatCtrl.value * math.pi) * -3.5;
              final waveProgress = _waveCtrl.value;

              return Transform.translate(
                offset: Offset(0, floatY),
                child: FussAvatar(
                  size: 116,
                  mood: FussMood.tired,
                  showSoundWaves: true,
                  soundWaveColor: Colors.white,
                  soundWaveProgress: waveProgress,
                ),
              );
            },
          ),

          // ── Floating Sleepy Z Particles ───────────────────────────
          Positioned(
            right: 80,
            top: 26,
            child: AnimatedBuilder(
              animation: _floatCtrl,
              builder: (context, _) {
                final drift = math.sin(_floatCtrl.value * math.pi) * 3;
                final op = 0.55 + 0.35 * math.sin(_floatCtrl.value * math.pi);
                return Opacity(
                  opacity: op.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(drift, -drift),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: const [
                        Text(
                          'z',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF9C92D6),
                            fontFamily: 'Figtree',
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'z',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFB6AEE2),
                            fontFamily: 'Figtree',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Orbiting Dots Painter ──────────────────────────────────────────────────
class _OrbitingDotsPainter extends CustomPainter {
  final double angle;

  static const _palette = [
    Color(0xFFF2B7A1), // Coral Peach
    Color(0xFFF5D985), // Warm Gold
    Color(0xFFB9E0D7), // Mint Sage
    Color(0xFFC9C3F0), // Lilac
    Color(0xFFA9C9EE), // Sky Blue
    Color(0xFFF6C9A8), // Apricot
  ];

  const _OrbitingDotsPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Faint orbital guide rings
    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(Offset(cx, cy), 68, ringPaint);
    canvas.drawCircle(Offset(cx, cy), 82, ringPaint);

    const int totalDots = 18;

    for (int i = 0; i < totalDots; i++) {
      // Stagger dots along the orbit
      final baseAngle = (i / totalDots) * 2 * math.pi;
      final currentAngle = baseAngle + angle;

      // Slight radial variation across tracks
      final double r = (i % 2 == 0) ? 68.0 : 82.0;
      final double dotRadius = (i % 3 == 0) ? 4.8 : (i % 2 == 0 ? 3.4 : 2.6);

      final x = cx + math.cos(currentAngle) * r;
      final y = cy + math.sin(currentAngle) * (r * 0.72); // gentle elliptical tilt

      // Subtle breath opacity
      final op = 0.55 + 0.40 * math.sin(currentAngle * 2);
      final color = _palette[i % _palette.length].withValues(alpha: op.clamp(0.25, 0.95));

      final dotPaint = Paint()..color = color;
      canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);

      // Soft glow aura for larger dots
      if (dotRadius > 4.0) {
        final glowPaint = Paint()
          ..color = color.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5);
        canvas.drawCircle(Offset(x, y), dotRadius + 2.0, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitingDotsPainter oldDelegate) =>
      oldDelegate.angle != angle;
}
