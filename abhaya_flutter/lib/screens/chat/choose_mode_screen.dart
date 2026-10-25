import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ChooseModeScreen extends StatefulWidget {
  final String? initialScenario;

  const ChooseModeScreen({super.key, this.initialScenario});

  @override
  State<ChooseModeScreen> createState() => _ChooseModeScreenState();
}

class _ChooseModeScreenState extends State<ChooseModeScreen> {
  int _selectedIndex = 0;
  String _scenario = 'Learn a topic';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['scenario'] != null) {
      _scenario = args['scenario'] as String;
    } else if (widget.initialScenario != null) {
      _scenario = widget.initialScenario!;
    }
  }

  final List<Map<String, dynamic>> _modes = [
    {
      'initials': 'MN',
      'title': 'Story mode',
      'subtitle': 'Real-life stories',
      'teacher': 'Dr. Meera Nair',
      'avatarBg': Color(0xFFD8F1EB),
      'avatarColor': Color(0xFF1A6A61),
    },
    {
      'initials': 'AM',
      'title': 'Step by step',
      'subtitle': 'One idea at a time',
      'teacher': 'Dr. Arjun Menon',
      'avatarBg': Color(0xFFECE6F8),
      'avatarColor': Color(0xFF6E4EA8),
    },
    {
      'initials': 'PI',
      'title': 'Quick notes',
      'subtitle': 'Brief key points',
      'teacher': 'Dr. Priya Iyer',
      'avatarBg': Color(0xFFFDEBE6),
      'avatarColor': Color(0xFFB9533B),
    },
    {
      'initials': 'VS',
      'title': 'In depth',
      'subtitle': 'Deep understanding',
      'teacher': 'Dr. Vikram Singh',
      'avatarBg': Color(0xFFE4F2F7),
      'avatarColor': Color(0xFF2A7E9C),
    },
    {
      'initials': 'KR',
      'title': 'Guided questions',
      'subtitle': 'I ask, you think',
      'teacher': 'Dr. Kavya Reddy',
      'avatarBg': Color(0xFFFAF1D9),
      'avatarColor': Color(0xFFA47B1E),
    },
    {
      'initials': 'RD',
      'title': 'Friendly chat',
      'subtitle': 'Relaxed and casual',
      'teacher': 'Dr. Rohan Das',
      'avatarBg': Color(0xFFE5EFE9),
      'avatarColor': Color(0xFF3D7856),
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
                    // Top Bar with Back Button and Centered Step 2 of 2 Indicator
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
                      'How should we',
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
                      'explain it?',
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
                      'Pick a teacher. You can switch anytime in the chat.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7E908B),
                        fontFamily: 'Figtree',
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Context Chip with "Change" button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 34,
                          padding: const EdgeInsets.only(left: 14, right: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD6EFE8),
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _scenario,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                  fontFamily: 'Figtree',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                height: 24,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Change',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E6B63),
                                    fontFamily: 'Figtree',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // 2-Column Grid of 6 Teaching Modes
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _modes.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.05,
                      ),
                      itemBuilder: (context, index) {
                        final m = _modes[index];
                        final isSelected = index == _selectedIndex;

                        return GestureDetector(
                          onTap: () => setState(() => _selectedIndex = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top row: Avatar initials + Radio button
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: m['avatarBg'] as Color,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        m['initials'] as String,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: m['avatarColor'] as Color,
                                          fontFamily: 'Figtree',
                                        ),
                                      ),
                                    ),
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
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Title
                                Text(
                                  m['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                    letterSpacing: -0.2,
                                    fontFamily: 'Figtree',
                                  ),
                                ),
                                const SizedBox(height: 2),

                                // Subtitle
                                Text(
                                  m['subtitle'] as String,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFF7E908B),
                                    fontFamily: 'Figtree',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const Spacer(),

                                // Teacher Name
                                Text(
                                  m['teacher'] as String,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1E6B63),
                                    fontFamily: 'Figtree',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Start chat Button Fixed at Bottom
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: GestureDetector(
                onTap: () {
                  final chosenTeacher = _modes[_selectedIndex]['teacher'] as String;
                  final chosenMode = _modes[_selectedIndex]['title'] as String;
                  Navigator.pushReplacementNamed(
                    context,
                    '/chat',
                    arguments: {
                      'character': chosenTeacher,
                      'mode': chosenMode,
                      'scenario': _scenario,
                    },
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
                        'Start chat',
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
