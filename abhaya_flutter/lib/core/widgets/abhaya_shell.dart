import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/chat/chat_list_screen.dart';
import '../../screens/wellbeing/wellbeing_screen.dart';
import '../../screens/exams/exam_setup_screen.dart';
import '../../screens/profile/profile_screen.dart';
import 'fuss_avatar.dart';

import '../../screens/chat/chat_centre_screen.dart';

class AbhayaShell extends StatefulWidget {
  const AbhayaShell({super.key});

  @override
  State<AbhayaShell> createState() => _AbhayaShellState();
}

class _AbhayaShellState extends State<AbhayaShell> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onNavigateTab: (index) => _onTap(index)),
      const ChatCentreScreen(),
      const WellbeingScreen(),
      const ExamSetupScreen(),
      const ProfileScreen(),
    ];
  }

  void _onTap(int index) {
    if (index == _selectedIndex) return;
    HapticFeedback.selectionClick();
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobileContent = Scaffold(
          backgroundColor: AppColors.bg,
          extendBody: true,
          body: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          bottomNavigationBar: _buildFloatingBottomNav(),
        );

        // When opened on desktop/web browser, show inside a sleek mobile phone frame
        if (constraints.maxWidth > 500) {
          return Scaffold(
            backgroundColor: const Color(0xFF0F1A18),
            body: Center(
              child: Container(
                width: 390,
                height: 844,
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(46),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 48,
                      offset: const Offset(0, 20),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFF233532), width: 7),
                ),
                clipBehavior: Clip.antiAlias,
                child: mobileContent,
              ),
            ),
          );
        }

        // Native mobile view on smartphone
        return mobileContent;
      },
    );
  }

  /// Authentic liquid-glass floating navigation bar from assets/abhaya.css (lines 308-320)
  Widget _buildFloatingBottomNav() {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        height: 72,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // Glass background pill
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFFE9EEEC), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF12302E).withValues(alpha: 0.12),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                      const BoxShadow(
                        color: Colors.white,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    children: [
                      // 0: Home
                      Expanded(
                        child: _buildStandardNavItem(
                          index: 0,
                          icon: Icons.home_outlined,
                          activeIcon: Icons.home_rounded,
                          label: 'Home',
                        ),
                      ),
                      // 1: Chat
                      Expanded(
                        child: _buildStandardNavItem(
                          index: 1,
                          icon: Icons.chat_bubble_outline_rounded,
                          activeIcon: Icons.chat_bubble_rounded,
                          label: 'Chat',
                        ),
                      ),
                      // 2: Wellbeing placeholder space for elevated orb
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _onTap(2),
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 34),
                              Text(
                                'Wellbeing',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: _selectedIndex == 2 ? FontWeight.w700 : FontWeight.w600,
                                  color: AppColors.ink,
                                  fontFamily: 'Figtree',
                                ),
                              ),
                              const SizedBox(height: 2),
                            ],
                          ),
                        ),
                      ),
                      // 3: Exams
                      Expanded(
                        child: _buildStandardNavItem(
                          index: 3,
                          icon: Icons.assignment_outlined,
                          activeIcon: Icons.assignment_turned_in_rounded,
                          label: 'Exams',
                        ),
                      ),
                      // 4: Profile
                      Expanded(
                        child: _buildStandardNavItem(
                          index: 4,
                          icon: Icons.person_outline_rounded,
                          activeIcon: Icons.person_rounded,
                          label: 'Profile',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Elevated Center Glowing Teal Orb for Wellbeing
            Positioned(
              top: -18,
              child: GestureDetector(
                onTap: () => _onTap(2),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          center: Alignment(-0.35, -0.45),
                          radius: 0.9,
                          colors: [
                            Color(0xFF5CC2B2),
                            Color(0xFF2A8A7E),
                            Color(0xFF14564F),
                          ],
                          stops: [0.0, 0.45, 1.0],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.95),
                          width: 4.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E6B63).withValues(alpha: 0.38),
                            blurRadius: 18,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: const Color(0xFF1E6B63).withValues(alpha: 0.15),
                            blurRadius: 0,
                            spreadRadius: 5.5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: FussAvatar(
                          size: 42,
                          mood: FussMood.calm,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStandardNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final selected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 46,
            height: 32,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFD5EFE6) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              selected ? activeIcon : icon,
              size: 21,
              color: selected ? AppColors.ink : AppColors.ink3,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? AppColors.ink : AppColors.ink3,
              fontFamily: 'Figtree',
            ),
          ),
        ],
      ),
    );
  }
}
