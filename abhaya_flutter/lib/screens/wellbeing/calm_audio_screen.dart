import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/abhaya_scaffold.dart';
import '../../core/widgets/meditation_orbit_scene.dart';

class CalmAudioScreen extends StatefulWidget {
  const CalmAudioScreen({super.key});

  @override
  State<CalmAudioScreen> createState() => _CalmAudioScreenState();
}

class _CalmAudioScreenState extends State<CalmAudioScreen> {
  int _selectedTrack = 0;
  bool _isPlaying = true;
  double _progress = 0.35;
  Timer? _ticker;

  final List<Map<String, dynamic>> _tracks = [
    {
      'title': 'Rain on leaves',
      'desc': 'Nature sounds for focus',
      'length': '10:00',
      'seconds': 600,
      'gradient': [
        const Color(0xFFCFE9DE),
        const Color(0xFF8FC2B2),
        const Color(0xFF5E9A8B),
      ],
    },
    {
      'title': 'Slow ocean waves',
      'desc': 'Unwind after a long shift',
      'length': '15:00',
      'seconds': 900,
      'gradient': [
        const Color(0xFFE1EDF3),
        const Color(0xFFA3C2D3),
        const Color(0xFF6F96AC),
      ],
    },
    {
      'title': 'Soft piano',
      'desc': 'Quiet music for study',
      'length': '20:00',
      'seconds': 1200,
      'gradient': [
        const Color(0xFFECE6F3),
        const Color(0xFFC3B6D8),
        const Color(0xFF9585B5),
      ],
    },
    {
      'title': 'Body scan for sleep',
      'desc': 'Guided, 8 minutes',
      'length': '08:00',
      'seconds': 480,
      'gradient': [
        const Color(0xFFF4E3DC),
        const Color(0xFFDDB5A8),
        const Color(0xFFC08A79),
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTicker();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isPlaying || !mounted) return;
      final totalSec = (_tracks[_selectedTrack]['seconds'] as int).toDouble();
      setState(() {
        _progress = (_progress + (1.0 / totalSec)).clamp(0.0, 1.0);
        if (_progress >= 1.0) {
          _isPlaying = false;
        }
      });
    });
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _skipSeconds(int delta) {
    final totalSec = (_tracks[_selectedTrack]['seconds'] as int).toDouble();
    setState(() {
      _progress = (_progress + (delta / totalSec)).clamp(0.0, 1.0);
    });
  }

  String _currentTimeString() {
    final totalSec = _tracks[_selectedTrack]['seconds'] as int;
    final curSec = (_progress * totalSec).round();
    final m = curSec ~/ 60;
    final s = curSec % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cur = _tracks[_selectedTrack];

    return AbhayaScaffold(
      title: 'Calm audio',
      subtitle: 'Relax and unwind',
      backgroundColor: const Color(0xFFF7F5FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main player card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ── Meditation Orbit Scene (Orbiting dots + .zz soundwaves) ──
                    MeditationOrbitScene(
                      gradientColors: cur['gradient'] as List<Color>,
                      isPlaying: _isPlaying,
                      height: 180,
                    ),
                    const SizedBox(height: 18),

                    // Track info
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('NOW PLAYING', style: AppTextStyles.eyebrow),
                          const SizedBox(height: 4),
                          Text(
                            cur['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                              letterSpacing: -0.3,
                              fontFamily: 'Figtree',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            cur['desc'],
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.ink2,
                              fontFamily: 'Figtree',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 6,
                        backgroundColor: AppColors.track,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF8B7EC8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _currentTimeString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.ink3,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Figtree',
                          ),
                        ),
                        Text(
                          cur['length'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.ink3,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Figtree',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Back 15s
                        IconButton(
                          onPressed: () => _skipSeconds(-15),
                          tooltip: 'Back 15 seconds',
                          icon: const Icon(
                            Icons.replay_10_rounded,
                            size: 28,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(width: 24),

                        // Play / Pause button (.play)
                        GestureDetector(
                          onTap: _togglePlay,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.deep,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.deep.withValues(alpha: 0.25),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Icon(
                              _isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),

                        // Forward 15s
                        IconButton(
                          onPressed: () => _skipSeconds(15),
                          tooltip: 'Forward 15 seconds',
                          icon: const Icon(
                            Icons.forward_10_rounded,
                            size: 28,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tracks', style: AppTextStyles.h3),
                  Text('4 sounds', style: AppTextStyles.meta),
                ],
              ),
              const SizedBox(height: 12),

              // Tracks List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _tracks.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final t = _tracks[i];
                  final isSelected = i == _selectedTrack;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTrack = i;
                        _isPlaying = true;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFFF2EFFB) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF8B7EC8)
                              : const Color(0xFFE7EDEB),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: t['gradient'] as List<Color>,
                              ),
                            ),
                            child: Icon(
                              isSelected && _isPlaying
                                  ? Icons.graphic_eq_rounded
                                  : Icons.music_note_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t['title'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: AppColors.ink,
                                    fontFamily: 'Figtree',
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  t['desc'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.ink3,
                                    fontFamily: 'Figtree',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            t['length'],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink2,
                              fontFamily: 'Figtree',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
