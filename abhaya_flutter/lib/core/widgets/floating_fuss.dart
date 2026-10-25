import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'fuss_avatar.dart';

/// Animated Fuss that feels like a living doll.
///
/// Animation layers:
///   1. Float + rotate   — 4 s sinusoidal vertical drift ±5 px, ±3°
///   2. Squish on bounce — horizontal squish at bottom, stretch at top
///   3. Blink            — random blink every 2.5–5 s (120 ms close/open)
///   4. Wiggle           — random head-shake every 5–9 s (sine-decay)
///   5. Sparkle pulse    — two 4-pt stars: teal top-left, gold bottom-right
///   6. Glow pulse       — slow 3 s radial teal halo breathes
class FloatingFuss extends StatefulWidget {
  final String greetingName;
  final VoidCallback? onTap;
  final double size;
  final FussMood mood;

  const FloatingFuss({
    super.key,
    required this.greetingName,
    this.onTap,
    this.size = 80,
    this.mood = FussMood.happy,
  });

  @override
  State<FloatingFuss> createState() => _FloatingFussState();
}

class _FloatingFussState extends State<FloatingFuss>
    with TickerProviderStateMixin {
  final _rng = math.Random();

  // 1. Float & rotate
  late final AnimationController _floatCtrl;
  late final Animation<double> _floatY;
  late final Animation<double> _floatRot;

  // 3. Blink
  late final AnimationController _blinkCtrl;
  late final Animation<double> _blinkAmount;
  Timer? _blinkTimer;

  // 4. Wiggle — driven by controller value via math.sin (no TweenSequence)
  late final AnimationController _wiggleCtrl;
  Timer? _wiggleTimer;

  // 5. Sparkles
  late final AnimationController _spark1Ctrl;
  late final Animation<double> _spark1Op;
  late final Animation<double> _spark1Sc;
  late final AnimationController _spark2Ctrl;
  late final Animation<double> _spark2Op;
  late final Animation<double> _spark2Sc;

  // 6. Glow pulse
  late final AnimationController _glowCtrl;
  late final Animation<double> _glowScale;
  late final Animation<double> _glowOpacity;

  @override
  void initState() {
    super.initState();

    // 1. Float ──────────────────────────────────────────────────────────────
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);
    _floatY = Tween<double>(begin: 0, end: -5)
        .animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    _floatRot = Tween<double>(
      begin: -3 * math.pi / 180,
      end: 3 * math.pi / 180,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    // 3. Blink ──────────────────────────────────────────────────────────────
    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _blinkAmount = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _blinkCtrl, curve: Curves.easeInOut));
    _scheduleBlink();

    // 4. Wiggle — simple controller; angle computed via sin in builder ───────
    _wiggleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scheduleWiggle();

    // 5. Sparkles ───────────────────────────────────────────────────────────
    _spark1Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
    _spark1Op = Tween<double>(begin: 0.35, end: 1.0)
        .animate(CurvedAnimation(parent: _spark1Ctrl, curve: Curves.easeInOut));
    _spark1Sc = Tween<double>(begin: 0.7, end: 1.1)
        .animate(CurvedAnimation(parent: _spark1Ctrl, curve: Curves.easeInOut));

    _spark2Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
      value: 1100 / 2600,
    )..repeat(reverse: true);
    _spark2Op = Tween<double>(begin: 0.35, end: 1.0)
        .animate(CurvedAnimation(parent: _spark2Ctrl, curve: Curves.easeInOut));
    _spark2Sc = Tween<double>(begin: 0.7, end: 1.1)
        .animate(CurvedAnimation(parent: _spark2Ctrl, curve: Curves.easeInOut));

    // 6. Glow ───────────────────────────────────────────────────────────────
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    _glowScale = Tween<double>(begin: 0.88, end: 1.14)
        .animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
    _glowOpacity = Tween<double>(begin: 0.18, end: 0.52)
        .animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
  }

  // Wiggle angle: decaying sine — no TweenSequence, no null risk
  double get _wiggleRad {
    final t = _wiggleCtrl.value; // 0 → 1
    if (t == 0.0) return 0.0;
    // 3 half-cycles that decay toward zero
    return (8 * math.pi / 180) * math.sin(6 * math.pi * t) * (1.0 - t);
  }

  void _scheduleBlink() {
    final ms = 2500 + _rng.nextInt(2500);
    _blinkTimer = Timer(Duration(milliseconds: ms), () async {
      if (!mounted) return;
      await _blinkCtrl.forward();
      if (!mounted) return;
      await _blinkCtrl.reverse();
      if (mounted) _scheduleBlink();
    });
  }

  void _scheduleWiggle() {
    final ms = 5000 + _rng.nextInt(4000);
    _wiggleTimer = Timer(Duration(milliseconds: ms), () async {
      if (!mounted) return;
      await _wiggleCtrl.forward();
      _wiggleCtrl.reset();
      if (mounted) _scheduleWiggle();
    });
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _blinkCtrl.dispose();
    _wiggleCtrl.dispose();
    _spark1Ctrl.dispose();
    _spark2Ctrl.dispose();
    _glowCtrl.dispose();
    _blinkTimer?.cancel();
    _wiggleTimer?.cancel();
    super.dispose();
  }

  Widget _sparkle(double sz, Color color, Animation<double> opA,
      Animation<double> scA) {
    return AnimatedBuilder(
      animation: Listenable.merge([opA, scA]),
      builder: (_, __) => Opacity(
        opacity: opA.value.clamp(0.0, 1.0),
        child: Transform.scale(
          scale: scA.value,
          child: SizedBox(
            width: sz,
            height: sz,
            child: CustomPaint(painter: _StarPainter(color: color)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canvas = widget.size * (92.0 / 78.0); // match CSS 92px container

    return GestureDetector(
      onTap: widget.onTap,
      // clipBehavior.none so the speech bubble and sparkles can bleed out
      child: SizedBox(
        width: canvas,
        height: canvas,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // ── 6. Glow pulse ──────────────────────────────────────────
            AnimatedBuilder(
              animation: _glowCtrl,
              builder: (_, __) => Transform.scale(
                scale: _glowScale.value,
                child: Opacity(
                  opacity: _glowOpacity.value,
                  child: Padding(
                    padding: EdgeInsets.all(canvas * 0.087),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Color(0xFF7EE0C4), Color(0x007EE0C4)],
                          stops: [0.0, 0.70],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── 1+2+3+4. Body: float, squish, blink, wiggle ────────────
            AnimatedBuilder(
              animation: Listenable.merge(
                  [_floatCtrl, _blinkCtrl, _wiggleCtrl]),
              builder: (_, __) {
                final t = _floatCtrl.value; // 0=bottom, 1=top
                // Squish: wider+shorter at bottom, thinner+taller at top
                final sx = 1.05 - 0.08 * t;
                final sy = 0.96 + 0.08 * t;

                // Wiggle overrides the float rotation while active
                final rot = _wiggleCtrl.isAnimating
                    ? _wiggleRad
                    : _floatRot.value;

                return Transform.translate(
                  offset: Offset(0, _floatY.value),
                  child: Transform.rotate(
                    angle: rot,
                    child: Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.diagonal3Values(sx, sy, 1.0),
                      child: FussAvatar(
                        size: widget.size,
                        mood: widget.mood,
                        blinkAmount: _blinkAmount.value.clamp(0.0, 1.0),
                      ),
                    ),
                  ),
                );
              },
            ),

            // ── Speech bubble — overlaps Fuss from above-left ─────────
            // right: ~48 keeps it within the avatar's bounds (no overflow)
            Positioned(
              top: -12,
              right: 46,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9FBF4),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'Hi ${widget.greetingName}!',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF123832),
                    fontFamily: 'Figtree',
                  ),
                ),
              ),
            ),

            // ── 5. Sparkle 1: 12×12, top-left, teal ───────────────────
            Positioned(
              top: 4,
              left: 6,
              child: _sparkle(
                  12, const Color(0xFFBFF3E2), _spark1Op, _spark1Sc),
            ),

            // ── 5. Sparkle 2: 8×8, bottom-right, gold ─────────────────
            Positioned(
              bottom: 12,
              right: 0,
              child: _sparkle(
                  8, const Color(0xFFFFD9A0), _spark2Op, _spark2Sc),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 4-point star CustomPainter ─────────────────────────────────────────────
class _StarPainter extends CustomPainter {
  final Color color;
  const _StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;
    final ri = r * 0.35;
    final path = Path();
    for (int i = 0; i < 4; i++) {
      final oa = (i * math.pi / 2) - math.pi / 2;
      final ia = oa + math.pi / 4;
      final ox = cx + r * math.cos(oa);
      final oy = cy + r * math.sin(oa);
      final ix = cx + ri * math.cos(ia);
      final iy = cy + ri * math.sin(ia);
      if (i == 0) path.moveTo(ox, oy); else path.lineTo(ox, oy);
      path.lineTo(ix, iy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _StarPainter old) => old.color != color;
}
