import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/abhaya_scaffold.dart';
import '../../core/widgets/pill_button.dart';

class DiagramResultScreen extends StatefulWidget {
  const DiagramResultScreen({super.key});

  @override
  State<DiagramResultScreen> createState() => _DiagramResultScreenState();
}

class _DiagramResultScreenState extends State<DiagramResultScreen> {
  int _selectedPin = 0;

  final List<Map<String, dynamic>> _parts = [
    {
      'key': 'A',
      'name': 'Right Atrium',
      'dx': 0.32,
      'dy': 0.38,
      'desc': 'Receives deoxygenated venous return from superior & inferior vena cava. Houses the SA Node.',
    },
    {
      'key': 'B',
      'name': 'Right Ventricle',
      'dx': 0.38,
      'dy': 0.65,
      'desc': 'Pumps blood through the pulmonary semilunar valve into pulmonary arteries toward the lungs.',
    },
    {
      'key': 'C',
      'name': 'Left Atrium',
      'dx': 0.65,
      'dy': 0.36,
      'desc': 'Receives high-oxygen blood from four pulmonary veins, passing it across the Mitral (Bicuspid) valve.',
    },
    {
      'key': 'D',
      'name': 'Left Ventricle',
      'dx': 0.62,
      'dy': 0.68,
      'desc': 'Generates high systolic pressure (120 mmHg) to eject blood through aortic valve into systemic circulation.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final cur = _parts[_selectedPin];

    return AbhayaScaffold(
      title: 'Human Heart Anatomy',
      subtitle: 'Part ${_selectedPin + 1} of ${_parts.length}',
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Diagram Canvas Stage with Interactive Pins
              Container(
                height: 240,
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    colors: [Color(0xFFFDEDE4), Color(0xFFF7D9CA)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFF0C5B1)),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final h = constraints.maxHeight;

                    return Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.favorite_rounded,
                            size: 130,
                            color: const Color(0xFFE8957A).withOpacity(0.5),
                          ),
                        ),
                        // Render interactive pins
                        ..._parts.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final part = entry.value;
                          final isSelected = idx == _selectedPin;

                          return Positioned(
                            left: (part['dx'] as double) * w - 18,
                            top: (part['dy'] as double) * h - 18,
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedPin = idx),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: isSelected ? 40 : 34,
                                height: isSelected ? 40 : 34,
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.deep : Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.ink.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    part['key'] as String,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected ? Colors.white : AppColors.ink,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Selected Part Explanation Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E6B63), Color(0xFF144D47)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PIN ${cur['key']}: ${cur['name']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cur['desc'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFD7EEE8),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),
              const Text('Anatomical Landmarks', style: AppTextStyles.h3),
              const SizedBox(height: 10),

              // Parts List Selector
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _parts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final part = _parts[index];
                  final isSelected = index == _selectedPin;

                  return InkWell(
                    onTap: () => setState(() => _selectedPin = index),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.mint2 : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.teal : AppColors.line,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.teal : AppColors.track,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                part['key'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? Colors.white : AppColors.ink,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              part['name'] as String,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_rounded, color: AppColors.teal, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: PillButton(
                      text: 'Ask AI Tutor',
                      icon: Icons.chat_bubble_outline_rounded,
                      height: 50,
                      onTap: () => Navigator.pushNamed(context, '/chat'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PillButton(
                      text: 'Test Me',
                      icon: Icons.assignment_outlined,
                      isPrimary: false,
                      isOutline: true,
                      height: 50,
                      onTap: () => Navigator.pushNamed(context, '/exam-question'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
