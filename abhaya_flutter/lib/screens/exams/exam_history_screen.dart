import 'package:flutter/material.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/abhaya_scaffold.dart';

class ExamHistoryScreen extends StatelessWidget {
  const ExamHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserService.instance,
      builder: (context, _) {
        final user = UserService.instance;
        final history = user.examHistory;

        return AbhayaScaffold(
          title: 'Exam history',
          subtitle: history.isEmpty ? '0 mocks' : '${history.length} mocks taken',
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Trend card with bar chart
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('AVERAGE SCORE', style: AppTextStyles.eyebrow),
                                const SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    text: '${user.examReadiness}',
                                    style: const TextStyle(
                                      fontSize: 38,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.ink,
                                      letterSpacing: -1,
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: '%',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.ink2),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: history.isEmpty ? const Color(0xFFF1F5F3) : const Color(0xFFE8F7F4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                history.isEmpty
                                    ? 'No tests yet'
                                    : 'Active: ${history.length} completed',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: history.isEmpty ? AppColors.ink3 : const Color(0xFF1D8776),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        if (history.isEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAF9),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE5EEEB)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE7F3EF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.bar_chart_rounded, color: Color(0xFF1E6B63), size: 26),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'No mock exam history yet',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Your scores and progress will appear here after taking your first test.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: Color(0xFF7E908B),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else ...[
                          // Bar Chart
                          SizedBox(
                            height: 150,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: history.reversed.take(6).toList().asMap().entries.map((e) {
                                final i = e.key;
                                final item = e.value;
                                final pct = item.percentage;
                                final isToday = i == (history.length > 6 ? 5 : history.length - 1);
                                final barHeight = ((pct / 100) * 115).clamp(10.0, 115.0);

                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (isToday)
                                          Container(
                                            margin: const EdgeInsets.only(bottom: 6),
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.deep,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              '$pct%',
                                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                                            ),
                                          ),
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          height: barHeight,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: isToday ? AppColors.teal : const Color(0xFFD3E5E1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '#${i + 1}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                                            color: isToday ? AppColors.ink : AppColors.ink3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent exams', style: AppTextStyles.h3),
                      Text('${history.length} completed', style: AppTextStyles.meta),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (history.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE5EEEB)),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'No exams taken yet. Start with a quick 10-question test.',
                        style: TextStyle(fontSize: 13, color: AppColors.ink2),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: history.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final e = history[i];
                        final pct = e.percentage;

                        Color scoreBg = const Color(0xFFEBF7F4);
                        Color scoreCol = const Color(0xFF1D8776);
                        if (pct < 60) {
                          scoreBg = const Color(0xFFFDEEEA);
                          scoreCol = const Color(0xFFB84B2E);
                        } else if (pct < 75) {
                          scoreBg = const Color(0xFFF7F2E4);
                          scoreCol = const Color(0xFF8A6A12);
                        }

                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/exam-result',
                            arguments: {
                              'subject': e.subject,
                              'format': e.format,
                              'score': e.score,
                              'total': e.total,
                            },
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFE5EEEB)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: scoreBg,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${e.score}/${e.total}',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: scoreCol),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${e.subject} · ${e.format}',
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Score: $pct% · ${e.total} questions',
                                        style: const TextStyle(fontSize: 12, color: AppColors.ink3),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_rounded, size: 18, color: AppColors.ink3),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/exam-setup'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      ),
                      child: const Text('New mock exam', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
