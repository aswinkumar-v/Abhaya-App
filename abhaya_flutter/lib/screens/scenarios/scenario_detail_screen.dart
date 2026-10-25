import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/pill_button.dart';

class ScenarioDetailScreen extends StatelessWidget {
  const ScenarioDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Column(
                      children: [
                        Text('Mr. Raj, 58', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink, fontFamily: 'Figtree')),
                        Text('Acute Myocardial Infarction', style: TextStyle(fontSize: 12, color: AppColors.ink3, fontFamily: 'Figtree')),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF163635), Color(0xFF1D4E48)]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Clinical Briefing', style: TextStyle(fontSize: 13, color: Color(0xFF8FDCC0), fontWeight: FontWeight.w600, fontFamily: 'Figtree')),
                          SizedBox(height: 8),
                          Text(
                            'Mr. Raj, a 58-year-old male, presents to the Emergency Department with crushing chest pain radiating to the left arm for the past 2 hours. He is diaphoretic and pale. Past medical history includes hypertension and Type 2 Diabetes.',
                            style: TextStyle(fontSize: 14, color: Colors.white, height: 1.6, fontFamily: 'Figtree'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _vitalsCard(),
                    const SizedBox(height: 24),
                    PillButton(
                      text: 'Begin Case',
                      icon: Icons.play_arrow_rounded,
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vitalsCard() {
    final vitals = [
      {'label': 'HR', 'value': '112 bpm', 'status': 'high'},
      {'label': 'BP', 'value': '90/60 mmHg', 'status': 'low'},
      {'label': 'SpO₂', 'value': '94%', 'status': 'low'},
      {'label': 'RR', 'value': '22/min', 'status': 'high'},
      {'label': 'Temp', 'value': '36.8°C', 'status': 'normal'},
      {'label': 'GCS', 'value': '15/15', 'status': 'normal'},
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Vital Signs', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.ink, fontFamily: 'Figtree')),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.8,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: vitals.map((v) {
              final Color color;
              switch (v['status']) {
                case 'high':
                  color = const Color(0xFFE07B8B);
                  break;
                case 'low':
                  color = const Color(0xFFD4956A);
                  break;
                default:
                  color = AppColors.teal;
              }
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(v['label']!, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color, fontFamily: 'Figtree')),
                    const SizedBox(height: 2),
                    Text(v['value']!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.ink, fontFamily: 'Figtree')),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
