import 'package:flutter/material.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ExamResultScreen extends StatelessWidget {
  const ExamResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final lastRecord = UserService.instance.examHistory.isNotEmpty ? UserService.instance.examHistory.first : null;
    final score = args?['score'] as int? ?? lastRecord?.score ?? 0;
    final total = args?['total'] as int? ?? lastRecord?.total ?? 10;
    final subject = args?['subject'] as String? ?? lastRecord?.subject ?? 'Medical-Surgical';
    final format = args?['format'] as String? ?? lastRecord?.format ?? 'MCQ';
    final List<Map<String, dynamic>> questions = (args?['reviewedQuestions'] as List<dynamic>?)
        ?.map((e) => Map<String, dynamic>.from(e as Map))
        .toList() ?? [
          {'title': 'Acute MI first line medication', 'correct': true},
          {'title': 'Hyperkalaemia early ECG changes', 'correct': true},
          {'title': 'Isotonic IV fluids identification', 'correct': false},
          {'title': 'Acute asthma rapid bronchodilation', 'correct': true},
        ];

    final pct = total > 0 ? ((score / total) * 100).round() : 0;
    final progressVal = total > 0 ? (score / total).clamp(0.0, 1.0) : 0.0;
    final adviceTitle = pct >= 70 ? 'Great clinical precision!' : 'Targeted revision recommended';
    final adviceBody = pct >= 70
        ? 'Strong grasp on primary interventions. Keep up your active recall sessions.'
        : 'Focus on your missed topics: ${UserService.instance.weakSpotsText}. Added to tomorrow’s plan.';

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.ink),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false),
        ),
        title: Column(
          children: [
            const Text('Results', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink)),
            Text('$subject · $format', style: const TextStyle(fontSize: 12, color: AppColors.ink3)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: AppColors.ink),
            onPressed: () => Navigator.pushNamed(context, '/exam-history'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Teal Score Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF163635), Color(0xFF1E5650)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deep.withValues(alpha: 0.2),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${pct >= 70 ? "Great job" : "Good effort"}, ${UserService.instance.greetingName}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.stars_rounded, size: 14, color: Color(0xFF7FCBBB)),
                              const SizedBox(width: 4),
                              Text('$pct%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    RichText(
                      text: TextSpan(
                        text: '$score',
                        style: const TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1.5,
                        ),
                        children: [
                          TextSpan(
                            text: '/$total',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF9ECEC5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: LinearProgressIndicator(
                        value: progressVal,
                        minHeight: 10,
                        backgroundColor: const Color(0xFF28544F),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7FCBBB)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 3 Stat tiles
              Row(
                children: [
                  _statBox('$score', 'Correct', const Color(0xFF2E9979)),
                  const SizedBox(width: 10),
                  _statBox('${(total - score).clamp(0, total)}', 'To revise', const Color(0xFFD65D45)),
                  const SizedBox(width: 10),
                  _statBox('4:15', 'Time', AppColors.ink),
                ],
              ),
              const SizedBox(height: 16),

              // AI Advice Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4F2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFC7E6DF)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.teal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            adviceTitle,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            adviceBody,
                            style: const TextStyle(fontSize: 12, color: AppColors.ink2, height: 1.35),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Question review header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Question review', style: AppTextStyles.h3),
                  const Text('Tap to discuss', style: TextStyle(fontSize: 12, color: AppColors.ink3)),
                ],
              ),
              const SizedBox(height: 12),

              // Review List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: questions.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final q = questions[i];
                  final isOk = q['correct'] as bool;
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/choose-mode'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5EEEB)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isOk ? const Color(0xFFE2F4EE) : const Color(0xFFFDE8E4),
                            ),
                            child: Icon(
                              isOk ? Icons.check_rounded : Icons.close_rounded,
                              size: 18,
                              color: isOk ? const Color(0xFF2E9979) : const Color(0xFFD65D45),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              q['title'],
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink),
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: AppColors.ink3, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, '/choose-mode'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFD2DCD8)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Review with AI', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/exam-setup'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('New exam', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statBox(String val, String label, Color valColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
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
            Text(
              val,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: valColor),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.ink3, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
