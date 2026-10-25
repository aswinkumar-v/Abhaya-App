import 'package:flutter/material.dart';
import '../../core/widgets/breathing_orb.dart';

enum BreathPhase { inhale, hold, exhale }

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  // ─── Animation ───────────────────────────────────────────────
  // Total cycle: 19s (Inhale 4s = 21%, Hold 7s = 37%, Exhale 8s = 42%)
  static const int _cycleSec = 19;
  static const int _totalRounds = 4;

  late final AnimationController _breatheCtrl;
  bool _isPaused = false;
  bool _sessionComplete = false;
  int _currentRound = 1;

  @override
  void initState() {
    super.initState();

    _breatheCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _cycleSec),
    );

    _breatheCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;
        if (_currentRound >= _totalRounds) {
          setState(() {
            _sessionComplete = true;
          });
        } else {
          setState(() {
            _currentRound++;
          });
          _breatheCtrl.forward(from: 0.0);
        }
      }
    });

    // Auto-start after frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _breatheCtrl.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _breatheCtrl.dispose();
    super.dispose();
  }

  void _beginSession() {
    if (!mounted) return;
    setState(() {
      _currentRound = 1;
      _isPaused = false;
      _sessionComplete = false;
    });
    _breatheCtrl.forward(from: 0.0);
  }

  void _togglePause() {
    if (_sessionComplete) {
      _beginSession();
      return;
    }
    setState(() {
      _isPaused = !_isPaused;
    });
    if (_isPaused) {
      _breatheCtrl.stop();
    } else {
      _breatheCtrl.forward();
    }
  }

  // ─── Phase pill helper ───────────────────────────────────────
  Widget _pill(String label, {required bool active}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active
            ? Colors.white.withValues(alpha: 0.18)
            : const Color(0xFF174035),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active
              ? Colors.white.withValues(alpha: 0.35)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: active ? FontWeight.w600 : FontWeight.w500,
          color: active
              ? Colors.white
              : Colors.white.withValues(alpha: 0.48),
          fontFamily: 'Figtree',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0D3830);
    final reducedMotion = MediaQuery.of(context).disableAnimations;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Back button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  // Title + subtitle
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Breathe',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Figtree',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '4-7-8 technique · 1 min',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.white.withValues(alpha: 0.65),
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Stage: Animated Orb + Labels + Phase Pills ───
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Orb & Halo
                  AnimatedBuilder(
                    animation: _breatheCtrl,
                    builder: (_, __) {
                      final t = _sessionComplete ? 0.0 : _breatheCtrl.value;
                      return BreathingOrb(
                        progress: t,
                        reducedMotion: reducedMotion,
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // ── Phase labels (.labs) — Cross-faded ─────────
                  AnimatedBuilder(
                    animation: _breatheCtrl,
                    builder: (_, __) {
                      if (_sessionComplete) {
                        return const SizedBox(
                          height: 36,
                          child: Center(
                            child: Text(
                              'Well done 🌿',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: -0.5,
                                fontFamily: 'Figtree',
                              ),
                            ),
                          ),
                        );
                      }

                      if (reducedMotion) {
                        return const SizedBox(
                          height: 36,
                          child: Center(
                            child: Text(
                              'Breathe slowly',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                letterSpacing: -0.5,
                                fontFamily: 'Figtree',
                              ),
                            ),
                          ),
                        );
                      }

                      final t = _breatheCtrl.value;
                      final opIn = BreathingOrb.computeLabelIn(t);
                      final opHold = BreathingOrb.computeLabelHold(t);
                      final opOut = BreathingOrb.computeLabelOut(t);

                      return SizedBox(
                        height: 36,
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // l1: Breathe in
                            Opacity(
                              opacity: opIn.clamp(0.0, 1.0),
                              child: const Text(
                                'Breathe in',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.5,
                                  color: Colors.white,
                                  fontFamily: 'Figtree',
                                ),
                              ),
                            ),
                            // l2: Hold
                            Opacity(
                              opacity: opHold.clamp(0.0, 1.0),
                              child: const Text(
                                'Hold',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.5,
                                  color: Colors.white,
                                  fontFamily: 'Figtree',
                                ),
                              ),
                            ),
                            // l3: Breathe out
                            Opacity(
                              opacity: opOut.clamp(0.0, 1.0),
                              child: const Text(
                                'Breathe out',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.5,
                                  color: Colors.white,
                                  fontFamily: 'Figtree',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // ── Phase pills (.phs) ─────────────────────────
                  AnimatedBuilder(
                    animation: _breatheCtrl,
                    builder: (_, __) {
                      final t = _breatheCtrl.value;
                      final isInhale = !_sessionComplete && t < 0.2105;
                      final isHold =
                          !_sessionComplete && t >= 0.2105 && t <= 0.5789;
                      final isExhale = !_sessionComplete && t > 0.5789;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _pill('In 4', active: isInhale),
                          const SizedBox(width: 8),
                          _pill('Hold 7', active: isHold),
                          const SizedBox(width: 8),
                          _pill('Out 8', active: isExhale),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // ── Bottom section: round dots + message + play button ─
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Round progress dots + label
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          _totalRounds,
                          (i) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (_sessionComplete || i < _currentRound)
                                  ? const Color(0xFF8FDCC0)
                                  : Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _sessionComplete
                            ? 'All $_totalRounds rounds complete'
                            : 'Round $_currentRound of $_totalRounds',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Four rounds settle your body before a shift or exam.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: Colors.white.withValues(alpha: 0.72),
                      fontFamily: 'Figtree',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Button (.br-play) ──────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _togglePause,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0D3830),
                        elevation: 10,
                        shadowColor: Colors.black.withValues(alpha: 0.18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _sessionComplete
                                ? Icons.refresh_rounded
                                : _isPaused
                                    ? Icons.play_arrow_rounded
                                    : Icons.pause_rounded,
                            size: 18,
                            color: const Color(0xFF0D3830),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _sessionComplete
                                ? 'Start again'
                                : _isPaused
                                    ? 'Resume'
                                    : 'Pause',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Figtree',
                              color: Color(0xFF0D3830),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
