import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/abhaya_scaffold.dart';

class DiagramTrainerScreen extends StatelessWidget {
  const DiagramTrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final library = [
      {'name': 'Heart Chambers', 'icon': Icons.favorite_rounded, 'color': AppColors.bad, 'bg': AppColors.blush},
      {'name': 'Nephron Unit', 'icon': Icons.filter_alt_rounded, 'color': AppColors.teal, 'bg': AppColors.mint},
      {'name': 'Brain Lobes', 'icon': Icons.psychology_rounded, 'color': AppColors.lilacInk, 'bg': AppColors.lilac},
      {'name': 'Eye Anatomy', 'icon': Icons.visibility_rounded, 'color': AppColors.skyInk, 'bg': AppColors.sky},
      {'name': 'Respiratory Tree', 'icon': Icons.air_rounded, 'color': AppColors.sandInk, 'bg': AppColors.sand},
      {'name': 'Reflex Arc', 'icon': Icons.electric_bolt_rounded, 'color': AppColors.sageInk, 'bg': AppColors.sage},
    ];

    return AbhayaScaffold(
      title: 'Diagram Trainer',
      subtitle: 'Visual Clinical Anatomy',
      actions: [
        IconButton(
          icon: const Icon(Icons.history_rounded, color: AppColors.teal),
          onPressed: () => Navigator.pushNamed(context, '/diagram-history'),
        ),
      ],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextStyles.twoToneHeadline(
                main: 'Learn. Visualize.',
                secondary: 'Understand.',
                fontSize: 24,
              ),
              const SizedBox(height: 6),
              const Text(
                'Explore clinical diagrams explained part-by-part with interactive labeling tests.',
                style: AppTextStyles.sub,
              ),
              const SizedBox(height: 20),

              // Upload & AI Create Row
              Row(
                children: [
                  Expanded(
                    child: _buildActionTile(
                      title: 'Upload',
                      desc: 'Scan textbook drawing',
                      icon: Icons.upload_file_rounded,
                      bg: AppColors.mintCardGradient,
                      color: AppColors.teal,
                      onTap: () => Navigator.pushNamed(context, '/upload-diagram'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionTile(
                      title: 'AI Generator',
                      desc: 'Describe & generate',
                      icon: Icons.auto_awesome_rounded,
                      bg: AppColors.lilacCardGradient,
                      color: AppColors.lilacInk,
                      onTap: () => Navigator.pushNamed(context, '/generate-diagram'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Featured Guided Tutorial
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/diagram-result'),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.mint2,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFBFE3D9)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: AppColors.teal,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 26),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Guided Tutorial: Heart Anatomy',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Interactive 3-minute label drill',
                              style: TextStyle(fontSize: 12, color: AppColors.teal),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.teal),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Diagram Library', style: AppTextStyles.h3),
                  Text('6 core systems', style: TextStyle(fontSize: 12, color: AppColors.ink3)),
                ],
              ),
              const SizedBox(height: 12),

              // Library Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.95,
                ),
                itemCount: library.length,
                itemBuilder: (context, index) {
                  final item = library[index];
                  return InkWell(
                    onTap: () => Navigator.pushNamed(context, '/diagram-result'),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      decoration: BoxDecoration(
                        color: item['bg'] as Color,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item['icon'] as IconData,
                              color: item['color'] as Color,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['name'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String desc,
    required IconData icon,
    required Gradient bg,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 130,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                Icon(Icons.arrow_forward_rounded, size: 18, color: color),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink),
                ),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 11, color: AppColors.ink3),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
