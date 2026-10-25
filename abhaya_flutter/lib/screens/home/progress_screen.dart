import 'package:flutter/material.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/abhaya_scaffold.dart';
import '../../core/widgets/stat_tile.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserService.instance,
      builder: (context, _) {
        final user = UserService.instance;
        final readiness = user.clinicalReadiness;
        final progressRatio = (readiness / 100.0).clamp(0.0, 1.0);
        final msProg = (user.examReadiness / 100.0).clamp(0.0, 1.0);

        return AbhayaScaffold(
          title: 'Learning Analytics',
          subtitle: 'Semester ${user.semester} Progress',
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextStyles.twoToneHeadline(
                    main: 'Your Performance',
                    secondary: 'consistent daily growth',
                    fontSize: 22,
                  ),
                  const SizedBox(height: 16),

                  // Overall Score Highlight Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E6B63), Color(0xFF134540)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.teal.withValues(alpha: 0.3),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ESTIMATED CLINICAL READINESS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF7EE0C4),
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$readiness%',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -1,
                              ),
                            ),
                            Text(
                              user.examHistory.isEmpty ? 'New learner' : '+${user.examHistory.length * 2}% this week',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF7EE0C4),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progressRatio,
                            minHeight: 8,
                            backgroundColor: const Color(0xFF1B534D),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7EE0C4)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4 Stat Tiles
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StatTile(label: 'Scenarios', value: '${user.scenariosCompleted}', icon: Icons.check_circle_outline),
                        StatTile(label: 'Flashcards', value: '${user.completedTaskCount * 5}', icon: Icons.style_outlined),
                        StatTile(label: 'Diagrams', value: '${user.savedDiagrams.length}', icon: Icons.architecture_outlined),
                        StatTile(label: 'Mock Tests', value: '${user.mockTestsTaken}', icon: Icons.assignment_outlined),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text('Mastery by Subject', style: AppTextStyles.h3),
                  const SizedBox(height: 12),

                  _buildSubjectProgress('Medical-Surgical Nursing', msProg, AppColors.teal),
                  _buildSubjectProgress('Pharmacology & Dosing', (msProg * 0.85).clamp(0.0, 1.0), AppColors.blushInk),
                  _buildSubjectProgress('Pediatric Patient Care', (msProg * 0.9).clamp(0.0, 1.0), AppColors.skyInk),
                  _buildSubjectProgress('Anatomy & Physiology', msProg, AppColors.ok),
                  _buildSubjectProgress('Mental Health Nursing', (msProg * 0.75).clamp(0.0, 1.0), AppColors.lilacInk),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubjectProgress(String subject, double val, Color color) {
    final pct = (val * 100).round();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subject, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              Text('$pct%', style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: val,
              minHeight: 6,
              backgroundColor: AppColors.track,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
