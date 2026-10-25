import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/abhaya_scaffold.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'Daily Streak Milestone! 🔥',
        'desc': 'You have maintained your study streak for 12 straight days.',
        'time': '10m ago',
        'unread': true,
        'icon': Icons.local_fire_department_rounded,
        'color': const Color(0xFFE88A3A),
      },
      {
        'title': 'New Clinical Case Added',
        'desc': 'Dr. Fuss added "Acute Pediatric Dehydration" to scenarios.',
        'time': '2h ago',
        'unread': true,
        'icon': Icons.medical_services_rounded,
        'color': AppColors.teal,
      },
      {
        'title': 'Pharmacology Quiz Reminder',
        'desc': 'Target 15 questions before your scheduled clinical round tomorrow.',
        'time': 'Yesterday',
        'unread': false,
        'icon': Icons.quiz_rounded,
        'color': AppColors.lilacInk,
      },
      {
        'title': 'Time to Unwind & Breathe',
        'desc': 'Take a 3-minute diaphragmatic breathing session with Fuss.',
        'time': '2d ago',
        'unread': false,
        'icon': Icons.spa_rounded,
        'color': AppColors.ok,
      },
    ];

    return AbhayaScaffold(
      title: 'Notifications',
      subtitle: 'Updates & Clinical Reminders',
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          itemCount: notifications.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final n = notifications[index];
            final unread = n['unread'] as bool;

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: unread ? AppColors.mint2 : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: unread ? const Color(0xFFBFE3D9) : AppColors.line,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: (n['color'] as Color).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      n['icon'] as IconData,
                      size: 20,
                      color: n['color'] as Color,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              n['title'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                            Text(
                              n['time'] as String,
                              style: const TextStyle(fontSize: 11, color: AppColors.ink3),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          n['desc'] as String,
                          style: const TextStyle(fontSize: 13, color: AppColors.ink2, height: 1.4),
                        ),
                      ],
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
