import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/abhaya_scaffold.dart';

class ActivityHistoryScreen extends StatelessWidget {
  const ActivityHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = [
      {
        'title': 'Chest Pain STEMI Scenario',
        'type': 'Clinical Simulation',
        'time': 'Today, 10:14 AM',
        'score': '100% correct',
        'icon': Icons.medical_services_rounded,
        'color': AppColors.teal,
      },
      {
        'title': 'Anatomy Conduction Diagram',
        'type': 'Diagram Trainer',
        'time': 'Today, 09:30 AM',
        'score': '8/8 labeled',
        'icon': Icons.draw_rounded,
        'color': AppColors.skyInk,
      },
      {
        'title': 'Cardiovascular Flashcards',
        'type': 'Spaced Repetition',
        'time': 'Yesterday, 8:45 PM',
        'score': '24 cards reviewed',
        'icon': Icons.style_rounded,
        'color': AppColors.blushInk,
      },
      {
        'title': 'Mock OSCE Medication Station',
        'type': 'Exam Preparation',
        'time': '2 days ago',
        'score': '92% pass',
        'icon': Icons.assignment_turned_in_rounded,
        'color': AppColors.lilacInk,
      },
    ];

    return AbhayaScaffold(
      title: 'Activity History',
      subtitle: 'Your Learning Log',
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          itemCount: history.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final h = history[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: (h['color'] as Color).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(h['icon'] as IconData, size: 20, color: h['color'] as Color),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          h['title'] as String,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${h['type']} · ${h['time']}',
                          style: const TextStyle(fontSize: 12, color: AppColors.ink3),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.mint2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      h['score'] as String,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.teal),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
