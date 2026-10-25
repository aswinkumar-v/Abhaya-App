import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/abhaya_scaffold.dart';

class QuestionPredictorScreen extends StatelessWidget {
  const QuestionPredictorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final predictions = [
      {
        'title': 'Anaphylaxis Immediate Nursing Management',
        'prob': '96% likelihood',
        'type': 'Long Answer (15 Marks)',
        'subject': 'Medical-Surgical Nursing',
        'years': 'Asked in 2021, 2023, 2024 university exams',
        'color': AppColors.bad,
      },
      {
        'title': 'Stages of Labor & Active Management (AMTSL)',
        'prob': '91% likelihood',
        'type': 'Clinical Case & Diagram',
        'subject': 'OBG Nursing',
        'years': 'Frequently repeated in viva and theory',
        'color': AppColors.teal,
      },
      {
        'title': 'Digoxin Toxicity & Nursing Precautions',
        'prob': '88% likelihood',
        'type': 'Short Notes (5 Marks)',
        'subject': 'Pharmacology',
        'years': 'Therapeutic levels, apical pulse monitoring',
        'color': AppColors.skyInk,
      },
      {
        'title': 'Glasgow Coma Scale (GCS) Assessment',
        'prob': '85% likelihood',
        'type': 'OSCE Practical Station',
        'subject': 'Critical Care & Neuro',
        'years': 'Standard station in 8 of the last 10 practicals',
        'color': AppColors.lilacInk,
      },
    ];

    return AbhayaScaffold(
      title: 'Question Predictor',
      subtitle: 'AI University Exam Analysis',
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          itemCount: predictions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final p = predictions[index];
            return Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.line),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.ink.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: (p['color'] as Color).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          p['prob'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: p['color'] as Color,
                          ),
                        ),
                      ),
                      Text(
                        p['type'] as String,
                        style: const TextStyle(fontSize: 11, color: AppColors.ink3),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    p['title'] as String,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p['subject'] as String,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.teal),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    p['years'] as String,
                    style: const TextStyle(fontSize: 12, color: AppColors.ink3),
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
