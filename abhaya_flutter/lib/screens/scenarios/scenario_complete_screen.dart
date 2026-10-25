import 'package:flutter/material.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ScenarioCompleteScreen extends StatelessWidget {
  const ScenarioCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        leading: const SizedBox(width: 48),
        title: Column(
          children: const [
            Text('Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink)),
            Text('Acute myocardial infarction', style: TextStyle(fontSize: 12, color: AppColors.ink3)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.ink),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextStyles.twoToneHeadline(
                main: 'Case complete',
                secondary: 'nicely reasoned, ${UserService.instance.greetingName}',
                fontSize: 22,
              ),
              const SizedBox(height: 16),

              // Teal summary with ring
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF163635), Color(0xFF1E5650)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    // Circular progress ring
                    Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [Color(0xFF9FE3D1), Color(0xFF9FE3D1), Color(0xFF28544F)],
                          stops: [0.0, 0.75, 1.0],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1D5B55),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '3/4',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Decisions matched',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '3 of 4 decisions matched an experienced nurse.',
                            style: TextStyle(fontSize: 13, color: Color(0xFFBCE3DC), height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Strengths Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('You did well', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2F4EE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('2 strengths', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF2E9979))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _strengthItem('Spotted ST elevation as the key ECG finding'),
                    const SizedBox(height: 10),
                    _strengthItem('Gave aspirin as the first medication'),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Revisit Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Worth reviewing', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDEEEA),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('1 to revisit', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFB84B2E))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFDE8E4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.priority_high_rounded, color: Color(0xFFD65D45), size: 18),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'When to escalate to the senior team as vitals change',
                            style: TextStyle(fontSize: 14, color: AppColors.ink, height: 1.35),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Clinical Guidelines Reference
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('References', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
                    const SizedBox(height: 10),
                    _refItem('AHA/ACC Guidelines for Management of STEMI, 2022.'),
                    const SizedBox(height: 8),
                    _refItem('Lewis et al., Medical-Surgical Nursing, 11th Ed.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, '/choose-mode'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFD0DCD8)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Discuss it', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Next case', style: TextStyle(fontWeight: FontWeight.w600)),
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

  Widget _strengthItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFE2F4EE),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: Color(0xFF2E9979), size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: AppColors.ink, height: 1.35),
          ),
        ),
      ],
    );
  }

  Widget _refItem(String citation) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.menu_book_outlined, size: 16, color: AppColors.ink3),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            citation,
            style: const TextStyle(fontSize: 12, color: AppColors.ink2, height: 1.35),
          ),
        ),
      ],
    );
  }
}
