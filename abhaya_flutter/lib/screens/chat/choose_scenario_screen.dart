import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ChooseScenarioScreen extends StatefulWidget {
  const ChooseScenarioScreen({super.key});

  @override
  State<ChooseScenarioScreen> createState() => _ChooseScenarioScreenState();
}

class _ChooseScenarioScreenState extends State<ChooseScenarioScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _options = [
    {
      'title': 'Learn a topic',
      'subtitle': 'Understand a concept from scratch',
      'icon': Icons.menu_book_outlined,
      'iconBg': Color(0xFFEAF5F2),
      'iconColor': Color(0xFF1E6B63),
    },
    {
      'title': 'Viva and exam prep',
      'subtitle': 'Practise like the real thing',
      'icon': Icons.assignment_outlined,
      'iconBg': Color(0xFFEFEBF8),
      'iconColor': Color(0xFF7654AC),
    },
    {
      'title': 'Discuss a patient case',
      'subtitle': 'Think through care decisions',
      'icon': Icons.monitor_heart_outlined,
      'iconBg': Color(0xFFFCEEE9),
      'iconColor': Color(0xFFC86248),
    },
    {
      'title': 'Clear a doubt',
      'subtitle': 'Quick help with one question',
      'icon': Icons.help_outline_rounded,
      'iconBg': Color(0xFFE8F4F8),
      'iconColor': Color(0xFF3885A3),
    },
    {
      'title': 'Surprise me',
      'subtitle': 'A random case to stay sharp',
      'icon': Icons.grid_view_rounded,
      'iconBg': Color(0xFFFBF3DF),
      'iconColor': Color(0xFFB88824),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Bar with Back Button and Centered Step 1 of 2 Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFE6ECEA)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.chevron_left_rounded,
                                size: 24,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                        ),

                        // Step Indicator
                        Column(
                          children: [
                            const Text(
                              'New chat',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                                fontFamily: 'Figtree',
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildStepBar(isActive: true),
                                const SizedBox(width: 6),
                                _buildStepBar(isActive: false),
                              ],
                            ),
                          ],
                        ),

                        // Placeholder for symmetry
                        const SizedBox(width: 44),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Title Headline
                    const Text(
                      'What would you like',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: -0.5,
                        fontFamily: 'Figtree',
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'to do today?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7E908B),
                        letterSpacing: -0.3,
                        fontFamily: 'Figtree',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Your teacher adapts to your pick.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7E908B),
                        fontFamily: 'Figtree',
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Options List
                    ...List.generate(_options.length, (index) {
                      final opt = _options[index];
                      final isSelected = index == _selectedIndex;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedIndex = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            height: 72,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(36),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF132A26) : const Color(0xFFE7EDEB),
                                width: isSelected ? 2 : 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isSelected ? 0.05 : 0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Icon Circle
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: opt['iconBg'] as Color,
                                  ),
                                  child: Icon(
                                    opt['icon'] as IconData,
                                    color: opt['iconColor'] as Color,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Texts
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        opt['title'] as String,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.ink,
                                          fontFamily: 'Figtree',
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        opt['subtitle'] as String,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF7E908B),
                                          fontFamily: 'Figtree',
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // Radio indicator
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFF132A26) : const Color(0xFFD2DCD7),
                                      width: isSelected ? 6.5 : 1.8,
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 4),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Continue Button Fixed at Bottom
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: GestureDetector(
                onTap: () {
                  final chosenScenario = _options[_selectedIndex]['title'] as String;
                  Navigator.pushNamed(
                    context,
                    '/choose-mode',
                    arguments: {'scenario': chosenScenario},
                  );
                },
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22645B),
                    borderRadius: BorderRadius.circular(27),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF22645B).withValues(alpha: 0.28),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Figtree',
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepBar({required bool isActive}) {
    return Container(
      width: 28,
      height: 5,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1E6B63) : const Color(0xFFE2EAE7),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
