import 'package:flutter/material.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  late final Set<String> _selectedTopics;
  late String _selectedWay;

  @override
  void initState() {
    super.initState();
    _selectedTopics = Set.from(UserService.instance.focusTopics);
    _selectedWay = UserService.instance.learningStyle;
  }

  final List<String> _topics = [
    'Anatomy',
    'Med-Surg',
    'Critical care',
    'Paediatrics',
    'Mental health',
    'Community',
    'Obstetrics',
    'Emergency',
    'Pharmacology',
    'Oncology',
    'Geriatrics',
    'Nutrition',
  ];

  final List<Map<String, dynamic>> _ways = [
    {
      'title': 'Stories',
      'subtitle': 'Real-life examples',
      'icon': Icons.menu_book_outlined,
    },
    {
      'title': 'Step by step',
      'subtitle': 'One idea at a time',
      'icon': Icons.trending_up_rounded,
    },
    {
      'title': 'Quick notes',
      'subtitle': 'Key points only',
      'icon': Icons.description_outlined,
    },
    {
      'title': 'Questions',
      'subtitle': 'Think it through',
      'icon': Icons.help_outline_rounded,
    },
  ];

  void _toggleTopic(String topic) {
    setState(() {
      if (_selectedTopics.contains(topic)) {
        _selectedTopics.remove(topic);
      } else if (_selectedTopics.length < 3) {
        _selectedTopics.add(topic);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar with Back Button and Centered Step 3 of 3 Indicator
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
                        'Step 3 of 3',
                        style: TextStyle(
                          fontSize: 14,
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
                          _buildStepBar(isActive: true),
                          const SizedBox(width: 6),
                          _buildStepBar(isActive: true),
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
                'Your focus',
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
                'change it anytime',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7E908B),
                  letterSpacing: -0.3,
                  fontFamily: 'Figtree',
                ),
              ),

              const SizedBox(height: 20),

              // Topics Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Topics',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                      letterSpacing: -0.2,
                      fontFamily: 'Figtree',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCF2EC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_selectedTopics.length} of 3 picked',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E6B63),
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 12 Topic Chips in Wrap
              Wrap(
                spacing: 8,
                runSpacing: 10,
                children: _topics.map((t) {
                  final isSelected = _selectedTopics.contains(t);
                  return GestureDetector(
                    onTap: () => _toggleTopic(t),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF132A26) : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF132A26) : const Color(0xFFE2EAE7),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        t,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.ink,
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // How you like to learn Section Header
              const Text(
                'How you like to learn',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  letterSpacing: -0.2,
                  fontFamily: 'Figtree',
                ),
              ),

              const SizedBox(height: 14),

              // 4 Radio Option Cards
              Column(
                children: _ways.map((w) {
                  final isSelected = w['title'] == _selectedWay;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedWay = w['title'] as String),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF132A26) : const Color(0xFFE2EAE7),
                            width: isSelected ? 1.8 : 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? const Color(0xFF132A26)
                                    : const Color(0xFFEEF2F0),
                              ),
                              child: Icon(
                                w['icon'] as IconData,
                                size: 18,
                                color: isSelected ? Colors.white : AppColors.ink,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    w['title'] as String,
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ink,
                                      fontFamily: 'Figtree',
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    w['subtitle'] as String,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: Color(0xFF7E908B),
                                      fontFamily: 'Figtree',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF132A26)
                                      : const Color(0xFFBDCBC7),
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Center(
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF132A26),
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Start learning Button
              GestureDetector(
                onTap: () {
                  UserService.instance.updateInterests(
                    topics: _selectedTopics.toList(),
                    way: _selectedWay,
                  );
                  Navigator.pushReplacementNamed(context, '/home');
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
                        'Start learning',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepBar({required bool isActive}) {
    return Container(
      width: 28,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1E6B63) : Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: !isActive ? Border.all(color: const Color(0xFFE2EAE7)) : null,
      ),
    );
  }
}
