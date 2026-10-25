import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Exact AI Tutor Celestial Orb from ChatCentre.dc.html & assets/abhaya.css:
/// 1. Orbiting Constellation Ring (.orbz .ring, 60s linear infinite spin)
///    with 22 colored dots at exact radii & colors from prototype.
/// 2. Glowing outer halo (.orbx::after, inset: -40px)
/// 3. Central luminous 3D sphere (.orbx.glow, 5s ease-in-out infinite pulse)
class CelestialTutorOrb extends StatefulWidget {
  final double size;
  final VoidCallback? onTap;

  const CelestialTutorOrb({
    super.key,
    this.size = 200,
    this.onTap,
  });

  @override
  State<CelestialTutorOrb> createState() => _CelestialTutorOrbState();
}

class _CelestialTutorOrbState extends State<CelestialTutorOrb>
    with TickerProviderStateMixin {
  // 1. Ring Spin: 60s continuous linear rotation (.ring { animation: spin 60s linear infinite })
  late final AnimationController _spinCtrl;

  // 2. Orb Glow: 5s ease-in-out pulse (.glow { animation: glow 5s ease-in-out infinite })
  //    scale: 1.0 -> 1.06, opacity: 0.85 -> 1.0
  late final AnimationController _glowCtrl;
  late final Animation<double> _glowScale;
  late final Animation<double> _glowOpacity;

  // 3. Subtle dot twinkle controller (3.2s ease-in-out)
  late final AnimationController _twinkleCtrl;

  // 4. Tap reaction spring controller
  late final AnimationController _tapCtrl;
  late final Animation<double> _tapScale;

  @override
  void initState() {
    super.initState();

    // 1. 60s linear spin
    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    // 2. 5s glow (2500ms * 2 with reverse)
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    _glowScale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );
    _glowOpacity = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );

    // 3. Subtle sparkle / twinkle cycle
    _twinkleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    // 4. Tap spring
    _tapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _tapScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.93), weight: 35),
      TweenSequenceItem(tween: Tween<double>(begin: 0.93, end: 1.04), weight: 35),
      TweenSequenceItem(tween: Tween<double>(begin: 1.04, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _tapCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _spinCtrl.dispose();
    _glowCtrl.dispose();
    _twinkleCtrl.dispose();
    _tapCtrl.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    _tapCtrl.forward(from: 0.0);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.of(context).disableAnimations;
    final scale = widget.size / 200.0;

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // ── 1. Spinning 22-Dot Constellation Ring (.orbz .ring) ──
            if (reduced)
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: const _ConstellationDotsPainter(twinkleVal: 0.5),
              )
            else
              AnimatedBuilder(
                animation: Listenable.merge([_spinCtrl, _twinkleCtrl]),
                builder: (context, _) {
                  return Transform.rotate(
                    angle: _spinCtrl.value * 2 * math.pi,
                    child: CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: _ConstellationDotsPainter(
                        twinkleVal: _twinkleCtrl.value,
                      ),
                    ),
                  );
                },
              ),

            // ── 2. Pulsing Glow Halo & 3D Sphere (.orbx.glow) ────────
            AnimatedBuilder(
              animation: Listenable.merge(
                reduced ? [_tapCtrl] : [_glowCtrl, _tapCtrl],
              ),
              builder: (context, _) {
                final pulseScale = reduced ? 1.0 : _glowScale.value;
                final pulseOpacity = reduced ? 0.95 : _glowOpacity.value;
                final tapSc = _tapCtrl.isAnimating ? _tapScale.value : 1.0;
                final combinedScale = pulseScale * tapSc * scale;

                return Transform.scale(
                  scale: combinedScale,
                  child: Opacity(
                    opacity: pulseOpacity.clamp(0.0, 1.0),
                    child: SizedBox(
                      width: 198, // 118 + 80 for inset: -40px halo
                      height: 198,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer diffuse halo (.orbx::after { inset: -40px })
                          Container(
                            width: 198,
                            height: 198,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                radius: 0.65,
                                colors: [
                                  const Color(0xFFBEE4D8).withValues(alpha: 0.55),
                                  const Color(0xFFBEE4D8).withValues(alpha: 0.0),
                                ],
                                stops: const [0.0, 0.65],
                              ),
                            ),
                          ),

                          // Inner soft aura
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFFBEE4D8).withValues(alpha: 0.45),
                                  const Color(0xFFBEE4D8).withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),

                          // Central 3D sphere (.orbx)
                          Container(
                            width: 118,
                            height: 118,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const RadialGradient(
                                center: Alignment(-0.30, -0.40), // circle at 35% 30%
                                radius: 0.85,
                                colors: [
                                  Color(0xFFFFFFFF), // 0%
                                  Color(0xFFD5EFE6), // 22%
                                  Color(0xFFB7E2D4), // 45%
                                  Color(0xFFF2C7AE), // 75%
                                  Color(0xFFC8C6F0), // 100%
                                ],
                                stops: [0.0, 0.22, 0.45, 0.75, 1.0],
                              ),
                              boxShadow: [
                                // box-shadow: 0 20px 50px rgba(120,170,160,.35)
                                BoxShadow(
                                  color: const Color(0xFF78AAA0).withValues(alpha: 0.35),
                                  blurRadius: 40,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 18),
                                ),
                                BoxShadow(
                                  color: const Color(0xFFB7E2D4).withValues(alpha: 0.25),
                                  blurRadius: 18,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Top-left specular gloss highlight for 3D sphere depth
                                Align(
                                  alignment: const Alignment(-0.35, -0.45),
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          Colors.white.withValues(alpha: 0.75),
                                          Colors.white.withValues(alpha: 0.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Exact 22 constellation dots from ChatCentre.dc.html
class _ConstellationDotsPainter extends CustomPainter {
  final double twinkleVal;

  const _ConstellationDotsPainter({this.twinkleVal = 0.5});

  static const _colors = [
    Color(0xFFF2B7A1),
    Color(0xFFF5D985),
    Color(0xFFB9E0D7),
    Color(0xFFC9C3F0),
    Color(0xFF9FD4C6),
    Color(0xFFF6C9A8),
    Color(0xFFD6E6E2),
    Color(0xFFA9C9EE),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const n = 22;
    final cx = size.width / 2.0;
    final cy = size.height / 2.0;
    final scale = size.width / 200.0;

    for (int i = 0; i < n; i++) {
      final a = (i / n) * math.pi * 2;
      // Formula from prototype: r = 86 + (i % 3) * 4
      final r = (86.0 + (i % 3) * 4.0) * scale;
      final baseSize = [10.0, 6.0, 8.0, 12.0, 7.0][i % 5] * scale;
      final baseOp = [1.0, 0.7, 0.9, 0.6][i % 4];

      // Subtle living twinkle
      final phase = math.sin((i * 1.3) + twinkleVal * math.pi * 2);
      final dynamicOp = (baseOp + phase * 0.12).clamp(0.4, 1.0);
      final dynamicSize = (baseSize + phase * 0.8).clamp(3.0, 15.0);

      final color = _colors[i % _colors.length].withValues(alpha: dynamicOp);
      final x = cx + math.cos(a) * r;
      final y = cy + math.sin(a) * r;

      canvas.drawCircle(Offset(x, y), dynamicSize / 2, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _ConstellationDotsPainter oldDelegate) =>
      oldDelegate.twinkleVal != twinkleVal;
}
