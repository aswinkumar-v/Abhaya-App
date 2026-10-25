import 'package:flutter/material.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/abhaya_scaffold.dart';
import '../../core/widgets/pill_button.dart';

class TodaysPlanScreen extends StatelessWidget {
  const TodaysPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserService.instance,
      builder: (context, _) {
        final tasks = UserService.instance.todayTasks;
        final completedCount = UserService.instance.completedTaskCount;
        final totalCount = UserService.instance.totalTaskCount;
        final progress = UserService.instance.todayProgress;

        return AbhayaScaffold(
          title: "Today's Clinical Plan",
          subtitle: "Personalized Daily Schedule",
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextStyles.twoToneHeadline(
                    main: "Daily Targets",
                    secondary: "stay ahead in your clinicals",
                    fontSize: 22,
                  ),
                  const SizedBox(height: 16),

                  // Progress Overview Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEAF5F1), Color(0xFFD7EEE8)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFBFE3D9)),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 58,
                              height: 58,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 6,
                                backgroundColor: Colors.white,
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.teal),
                              ),
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.teal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$completedCount of $totalCount tasks completed',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                completedCount == totalCount
                                    ? 'All daily targets completed! Amazing work.'
                                    : 'Estimated remaining: ${(totalCount - completedCount) * 15} minutes',
                                style: const TextStyle(fontSize: 12, color: AppColors.ink2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text('Scheduled Learning Tasks', style: AppTextStyles.h3),
                  const SizedBox(height: 12),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final isDone = task.completed;

                      return GestureDetector(
                        onTap: () => UserService.instance.toggleTask(index),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDone ? const Color(0xFFBFE3D9) : AppColors.line,
                            ),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: isDone,
                                activeColor: AppColors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                onChanged: (val) {
                                  UserService.instance.toggleTask(index);
                                },
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isDone ? AppColors.mute : AppColors.ink,
                                        decoration: isDone ? TextDecoration.lineThrough : null,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${task.subject} · ${task.duration}',
                                      style: const TextStyle(fontSize: 12, color: AppColors.ink3),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: task.color.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  task.icon,
                                  size: 16,
                                  color: task.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 28),
                  PillButton(
                    text: 'Start Next Clinical Activity',
                    icon: Icons.play_arrow_rounded,
                    height: 50,
                    onTap: () {
                      final firstIncomplete = tasks.indexWhere((t) => !t.completed);
                      if (firstIncomplete >= 0) {
                        final task = tasks[firstIncomplete];
                        if (task.subject.contains('Critical')) {
                          Navigator.pushNamed(context, '/scenarios');
                        } else if (task.subject.contains('Diagram')) {
                          Navigator.pushNamed(context, '/diagram-trainer');
                        } else {
                          Navigator.pushNamed(context, '/exam-question');
                        }
                      } else {
                        Navigator.pushNamed(context, '/exam-setup');
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
