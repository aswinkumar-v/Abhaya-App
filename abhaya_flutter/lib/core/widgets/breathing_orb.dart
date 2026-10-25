import 'package:flutter/material.dart';
import 'fuss_avatar.dart';

/// Breathing orb widget following the Abhaya prototype specification:
/// - 260×260 wrapper with radial halo glow
/// - Scaled orb with inset ring (inset: 38px)
/// - Centered Fuss character with smooth open/close eye transitions
class BreathingOrb extends StatelessWidget {
  /// Current progress through the 19s cycle (0.0 to 1.0)
  final double progress;
  /// Explicit scale override (if driven by CurvedAnimation), or null to compute
  final double? scale;
  /// Explicit halo opacity override (if driven by CurvedAnimation), or null to compute
  final double? haloOpacity;
  /// Explicit eye closed ratio (0.0 = open, 1.0 = closed), or null to compute
  final double? eyeClosedAmount;
  /// Whether reduced motion is active
  final bool reducedMotion;

  const BreathingOrb({
    super.key,
    required this.progress,
    this.scale,
    this.haloOpacity,
    this.eyeClosedAmount,
    this.reducedMotion = false,
  });

  // Keyframes computation matching CSS:
  // @keyframes breathe: 0% scale(.7), 21% scale(1), 58% scale(1), 100% scale(.7)
  static double computeScale(double t) {
    if (t < 0.21) {
      final p = Curves.easeInOut.transform(t / 0.21);
      return 0.7 + 0.3 * p;
    } else if (t <= 0.58) {
      return 1.0;
    } else {
      final p = Curves.easeInOut.transform((t - 0.58) / 0.42);
      return 1.0 - 0.3 * p;
    }
  }

  // @keyframes haloP: 0% opacity(.35), 21% & 58% opacity(1), 100% opacity(.35)
  static double computeHaloOpacity(double t) {
    if (t < 0.21) {
      final p = Curves.easeInOut.transform(t / 0.21);
      return 0.35 + 0.65 * p;
    } else if (t <= 0.58) {
      return 1.0;
    } else {
      final p = Curves.easeInOut.transform((t - 0.58) / 0.42);
      return 1.0 - 0.65 * p;
    }
  }

  // Character eyes: open on inhale (0→20%), closed on hold (22→56%), open on exhale (58→100%)
  // eyeC keyframes: 0-20% = 0, 22-56% = 1, 58-100% = 0
  static double computeEyeClosed(double t) {
    if (t < 0.20) {
      return 0.0;
    } else if (t < 0.22) {
      return (t - 0.20) / 0.02; // crossfade open -> closed
    } else if (t <= 0.56) {
      return 1.0; // closed
    } else if (t < 0.58) {
      return 1.0 - ((t - 0.56) / 0.02); // crossfade closed -> open
    } else {
      return 0.0; // open
    }
  }

  // Phase labels keyframes
  // lin ("Breathe in"): 0-20% = 1, 22-100% = 0
  static double computeLabelIn(double t) {
    if (t < 0.20) return 1.0;
    if (t < 0.22) return 1.0 - ((t - 0.20) / 0.02);
    return 0.0;
  }

  // lhold ("Hold"): 0-21% = 0, 23-56% = 1, 58-100% = 0
  static double computeLabelHold(double t) {
    if (t < 0.21) return 0.0;
    if (t < 0.23) return (t - 0.21) / 0.02;
    if (t <= 0.56) return 1.0;
    if (t < 0.58) return 1.0 - ((t - 0.56) / 0.02);
    return 0.0;
  }

  // lout ("Breathe out"): 0-57% = 0, 59-98% = 1, 100% = 0
  static double computeLabelOut(double t) {
    if (t < 0.57) return 0.0;
    if (t < 0.59) return (t - 0.57) / 0.02;
    if (t <= 0.98) return 1.0;
    return 1.0 - ((t - 0.98) / 0.02);
  }

  @override
  Widget build(BuildContext context) {
    if (reducedMotion) {
      return _buildContent(
        effectiveScale: 0.88,
        effectiveHaloOpacity: 0.80,
        effectiveEyeClosed: 1.0,
      );
    }

    final t = progress.clamp(0.0, 1.0);
    final s = scale ?? computeScale(t);
    final h = haloOpacity ?? computeHaloOpacity(t);
    final e = eyeClosedAmount ?? computeEyeClosed(t);

    return _buildContent(
      effectiveScale: s,
      effectiveHaloOpacity: h,
      effectiveEyeClosed: e,
    );
  }

  Widget _buildContent({
    required double effectiveScale,
    required double effectiveHaloOpacity,
    required double effectiveEyeClosed,
  }) {
    // 260px container (.orbwrap)
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // ── Radial glow behind the orb (.halo) ─────────────────────
          Opacity(
            opacity: effectiveHaloOpacity.clamp(0.0, 1.0),
            child: Container(
              width: 260,
              height: 260,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0x6B8FDCC0), // rgba(143,220,192,.42)
                    Color(0x248FDCC0), // rgba(143,220,192,.14)
                    Color(0x008FDCC0), // rgba(143,220,192,0)
                  ],
                  stops: [0.0, 0.52, 0.70],
                ),
              ),
            ),
          ),

          // ── The orb (.orb) — scales with breath ────────────────────
          Transform.scale(
            scale: effectiveScale,
            child: SizedBox(
              width: 260,
              height: 260,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Inner ring decoration (.ring: inset 38px -> 184×184)
                  Positioned(
                    top: 38,
                    left: 38,
                    right: 38,
                    bottom: 38,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0x47DDEFE7), // rgba(221,239,231,.28)
                          width: 1,
                        ),
                        color: const Color(0x12DDEFE7), // rgba(221,239,231,.07)
                      ),
                    ),
                  ),

                  // Fuss mascot with dynamic open/closed eyes
                  FussAvatar(
                    size: 168,
                    mood: FussMood.calm,
                    eyeClosedAmount: effectiveEyeClosed,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
