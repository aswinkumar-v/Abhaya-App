import 'package:flutter/material.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/fuss_avatar.dart';
import '../../core/widgets/floating_fuss.dart';
import '../../core/widgets/nurse_avatar.dart';
import '../../core/widgets/feature_icons.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedMood = 'Good';

  final List<Map<String, dynamic>> _moods = [
    {'name': 'Great', 'mood': FussMood.happy, 'msg': 'Lovely! Ride that energy into today’s case.'},
    {'name': 'Good', 'mood': FussMood.calm, 'msg': 'Nice. You’re halfway through today’s plan.'},
    {'name': 'Okay', 'mood': FussMood.okay, 'msg': 'Steady is fine. Start with the shortest task.'},
    {'name': 'Stressed', 'mood': FussMood.stressed, 'msg': 'Let’s take a 1 minute breather first.'},
    {'name': 'Low', 'mood': FussMood.sad, 'msg': 'Be gentle with yourself. One small task is enough.'},
  ];

  @override
  Widget build(BuildContext context) {
    final curMoodObj = _moods.firstWhere((m) => m['name'] == _selectedMood);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: ListenableBuilder(
        listenable: UserService.instance,
        builder: (context, _) => SingleChildScrollView(
        child: Column(
          children: [
            // ==========================================
            // TOP SECTION: Dark Teal Curved Header
            // ==========================================
            Container(
              padding: const EdgeInsets.fromLTRB(18, 52, 18, 42),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF123832), Color(0xFF16463F), Color(0xFF1A5249)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: [
                  // Decorative dashed circle background ring
                  Positioned(
                    right: -50,
                    top: 20,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1.5),
                      ),
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Profile avatar & Notification bell
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Glassmorphism Profile Pill with Nurse Avatar
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/profile'),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.14),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: NurseAvatar(size: 34),
                              ),
                            ),
                          ),

                          // Glassmorphism Notification Bell
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/notifications'),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.14),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
                                  Positioned(
                                    right: 11,
                                    top: 10,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF7EE0C4),
                                        border: Border.all(color: const Color(0xFF1A574F), width: 1.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Hero section: Headline + Mascot
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tutor tag
                                Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF7EE0C4),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF7EE0C4).withValues(alpha: 0.4),
                                            blurRadius: 6,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'ABHAYA TUTOR · 24/7',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                        color: Color(0xFFBCE3DC),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Headline
                                RichText(
                                  text: const TextSpan(
                                    text: 'Ask anything,\n',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      height: 1.2,
                                      fontFamily: 'Figtree',
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'learn your way',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF90B5AD),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Fuss mascot — floating animated (ghf + ghs keyframes)
                          FloatingFuss(
                            greetingName: UserService.instance.greetingName,
                            mood: FussMood.happy,
                            size: 80,
                            onTap: () => Navigator.pushNamed(context, '/choose-scenario'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Action Pills: + New chat & Resume
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/choose-scenario'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFFD6FAEE).withValues(alpha: 0.45),
                                    Colors.white.withValues(alpha: 0.2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.add_rounded, size: 16, color: Colors.white),
                                  SizedBox(width: 6),
                                  Text(
                                    'New chat',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/chat'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.refresh_rounded, size: 16, color: Colors.white),
                                  SizedBox(width: 6),
                                  Text(
                                    'Resume',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ==========================================
            // SHEET SECTION: White curved body
            // ==========================================
            Transform.translate(
              offset: const Offset(0, -18),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                ),
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title: Learn
                    const Text(
                      'Learn',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // 2x2 Grid of Feature Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildFeatureCard(
                            title: 'Notes Buddy',
                            subtitle: 'Notes, flashcards, papers',
                            iconWidget: const NotesBuddyIcon(size: 20, color: AppColors.teal),
                            gradient: const [Color(0xFFE4F4EF), Color(0xFFC8E8DE)],
                            onTap: () => Navigator.pushNamed(context, '/notes-buddy'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildFeatureCard(
                            title: 'Diagram Trainer',
                            subtitle: 'Upload or generate',
                            iconWidget: const DiagramTrainerIcon(size: 20, color: Color(0xFFB5603F)),
                            gradient: const [Color(0xFFFDEDE4), Color(0xFFF6D3C2)],
                            onTap: () => Navigator.pushNamed(context, '/diagram-trainer'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFeatureCard(
                            title: 'Clinical Cases',
                            subtitle: UserService.instance.scenariosCompleted == 0
                                ? '3 patient cases'
                                : '${UserService.instance.scenariosCompleted} cases completed',
                            iconWidget: const ClinicalCasesIcon(size: 20, color: Color(0xFF2F6F8F)),
                            gradient: const [Color(0xFFE6F1F6), Color(0xFFCBE1EC)],
                            onTap: () => Navigator.pushNamed(context, '/scenarios'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildFeatureCard(
                            title: 'Mock Exams',
                            subtitle: UserService.instance.mockTestsTaken == 0
                                ? 'Practice now'
                                : '${UserService.instance.mockTestsTaken} completed',
                            iconWidget: const MockExamsIcon(size: 20, color: Color(0xFF6150B5)),
                            gradient: const [Color(0xFFEFEDFB), Color(0xFFDAD4F4)],
                            onTap: () => Navigator.pushNamed(context, '/exam-setup'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Today's Progress Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFE6ECEA)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Top row: ring + cardiovascular system
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/todays-plan'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFFEAF6F1), Color(0xFFF6FBF9), Colors.white],
                                  stops: [0.0, 0.7, 1.0],
                                ),
                                borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
                              ),
                              child: Row(
                                children: [
                                  // Dynamic Circular Ring
                                  SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          value: UserService.instance.todayProgress,
                                          strokeWidth: 4,
                                          backgroundColor: const Color(0xFFD6E9E3),
                                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.teal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'TODAY · ${UserService.instance.completedTaskCount} OF ${UserService.instance.totalTaskCount} DONE',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                            color: AppColors.teal,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          UserService.instance.focusTopics.isNotEmpty
                                              ? '${UserService.instance.focusTopics.first} system'
                                              : 'Cardiovascular system',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.ink,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 6),
                                      ],
                                    ),
                                    child: const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.teal),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Bottom row: 3 stats strip (7 Day streak, 78% Exam ready, 3.3h This week)
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/progress'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                              child: Row(
                                children: [
                                  _buildStatItem('${UserService.instance.streakDays}', 'Day streak', isStreak: true),
                                  Container(width: 1, height: 28, color: const Color(0xFFE6ECEA)),
                                  _buildStatItem('${UserService.instance.examReadiness}%', 'Exam ready'),
                                  Container(width: 1, height: 28, color: const Color(0xFFE6ECEA)),
                                  _buildStatItem('${UserService.instance.studyHoursThisWeek}h', 'This week'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Mood Check-in with Fuss
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF6F4FD), Color(0xFFEEEAFB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFE7E2F7)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              FussAvatar(size: 64, mood: curMoodObj['mood'] as FussMood),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Hi, I'm Fuss. How are you feeling?",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      UserService.instance.completedTaskCount == 0
                                          ? "Welcome! Ready to start today's plan? Let's take the first step."
                                          : curMoodObj['msg'] as String,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.ink2,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 5 Mood Chips with Miniature Fuss Mascots
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F7F6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: _moods.map((m) {
                                final name = m['name'] as String;
                                final mood = m['mood'] as FussMood;
                                final isSel = name == _selectedMood;

                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() => _selectedMood = name);
                                      UserService.instance.recordMoodCheckIn(name);
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSel ? Colors.white : Colors.transparent,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: isSel
                                            ? [
                                                BoxShadow(
                                                  color: const Color(0xFF12302E).withValues(alpha: 0.1),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          FussAvatar(size: 32, mood: mood),
                                          const SizedBox(height: 6),
                                          Text(
                                            name,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                              color: isSel ? AppColors.ink : AppColors.ink2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Aligned to the left: More in Wellbeing →
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/wellbeing'),
                              child: const Text(
                                'More in Wellbeing →',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6A5FC0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 90),
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

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required Widget iconWidget,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 114,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0x1512302E),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative background circle
            Positioned(
              right: -24,
              bottom: -32,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
            ),

            // Arrow button in top right
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.65),
                ),
                child: const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.ink),
              ),
            ),

            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(child: iconWidget),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.ink2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String val, String label, {bool isStreak = false}) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isStreak) ...[
                const Icon(Icons.local_fire_department_rounded, color: Color(0xFFD08A2E), size: 18),
                const SizedBox(width: 2),
              ],
              Text(
                val,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.ink3,
            ),
          ),
        ],
      ),
    );
  }
}
