import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/abhaya_scaffold.dart';

class PastPapersScreen extends StatelessWidget {
  const PastPapersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final papers = [
      {'year': '2025 Regular', 'title': 'Medical-Surgical Nursing I & II', 'questions': 25, 'solved': true},
      {'year': '2024 Supplementary', 'title': 'Pharmacology, Pathology & Genetics', 'questions': 20, 'solved': true},
      {'year': '2024 Regular', 'title': 'Community Health Nursing I', 'questions': 18, 'solved': false},
      {'year': '2023 Regular', 'title': 'Child Health & Pediatric Nursing', 'questions': 22, 'solved': true},
      {'year': '2022 Regular', 'title': 'Mental Health & Psychiatric Nursing', 'questions': 20, 'solved': false},
    ];

    return AbhayaScaffold(
      title: 'Past Question Papers',
      subtitle: 'University Examination Repository',
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          itemCount: papers.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final p = papers[index];
            final isSolved = p['solved'] as bool;

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
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSolved ? AppColors.mint2 : AppColors.track,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.description_rounded,
                      color: isSolved ? AppColors.teal : AppColors.ink3,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['year'] as String,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.ink3),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          p['title'] as String,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${p['questions']} Questions · ${isSolved ? 'Model answers available' : 'Practice set'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isSolved ? AppColors.ok : AppColors.ink2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.ink3),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
