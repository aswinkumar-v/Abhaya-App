import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/abhaya_scaffold.dart';

class NotesBuddyScreen extends StatefulWidget {
  const NotesBuddyScreen({super.key});

  @override
  State<NotesBuddyScreen> createState() => _NotesBuddyScreenState();
}

class _NotesBuddyScreenState extends State<NotesBuddyScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Med-Surg', 'Pharmacology', 'Pediatrics', 'Anatomy'];

  final List<Map<String, dynamic>> _notes = [
    {
      'subject': 'Medical-Surgical',
      'title': 'Shock Classification & Hemodynamics',
      'summary': 'Cardiogenic, hypovolemic, septic, anaphylactic shock protocols and fluids.',
      'flashcards': 24,
      'readTime': '8 min read',
      'color': AppColors.teal,
    },
    {
      'subject': 'Pharmacology',
      'title': 'Autonomic Nervous System Drugs',
      'summary': 'Sympathomimetics, beta blockers, anticholinergics with dosing formulas.',
      'flashcards': 36,
      'readTime': '12 min read',
      'color': AppColors.blushInk,
    },
    {
      'subject': 'Pediatrics',
      'title': 'Developmental Milestones & Growth Charts',
      'summary': 'Gross motor, fine motor, social, language milestones 0–5 years.',
      'flashcards': 18,
      'readTime': '6 min read',
      'color': AppColors.skyInk,
    },
    {
      'subject': 'Anatomy',
      'title': 'Cardiac Conduction & Coronary Circulation',
      'summary': 'SA node, AV node, bundle branches, and ECG vector correlations.',
      'flashcards': 30,
      'readTime': '10 min read',
      'color': AppColors.lilacInk,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AbhayaScaffold(
      title: 'Notes Buddy',
      subtitle: 'Clinical Study Library',
      actions: [
        IconButton(
          icon: const Icon(Icons.history_rounded, color: AppColors.teal),
          onPressed: () => Navigator.pushNamed(context, '/activity-history'),
        ),
      ],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Current Reading In-Progress Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E6B63), Color(0xFF134540)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.teal.withOpacity(0.25),
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
                      children: const [
                        Text(
                          'CONTINUE READING',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: Color(0xFF7EE0C4),
                          ),
                        ),
                        Text(
                          '65% done',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Parenteral Fluid Therapy & Electrolytes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Semester 3 · Medical-Surgical Nursing',
                      style: TextStyle(fontSize: 12, color: Color(0xFFBFE3D9)),
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: const LinearProgressIndicator(
                        value: 0.65,
                        minHeight: 6,
                        backgroundColor: Color(0xFF18524B),
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7EE0C4)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3 Quick Action Study Tools
              Row(
                children: [
                  Expanded(
                    child: _buildToolTile(
                      context,
                      title: 'Flashcards',
                      subtitle: 'Active recall',
                      icon: Icons.style_rounded,
                      bg: const Color(0xFFE4F4EF),
                      fg: AppColors.teal,
                      route: '/flashcards',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildToolTile(
                      context,
                      title: 'Predictor',
                      subtitle: 'Exam trends',
                      icon: Icons.insights_rounded,
                      bg: const Color(0xFFFDEDE4),
                      fg: AppColors.blushInk,
                      route: '/question-predictor',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildToolTile(
                      context,
                      title: 'Past Papers',
                      subtitle: 'University sets',
                      icon: Icons.folder_copy_rounded,
                      bg: const Color(0xFFEFEDFB),
                      fg: AppColors.lilacInk,
                      route: '/past-papers',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Category Pills
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = cat == _selectedCategory;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.deep : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.deep : AppColors.line,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          cat,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : AppColors.ink,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 18),
              const Text('High-Yield Study Notes', style: AppTextStyles.h3),
              const SizedBox(height: 12),

              // Notes List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _notes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final n = _notes[index];
                  return InkWell(
                    onTap: () => Navigator.pushNamed(context, '/subject-notes'),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.line),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.ink.withOpacity(0.04),
                            blurRadius: 8,
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
                              Text(
                                n['subject'] as String,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: n['color'] as Color,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.style_outlined, size: 14, color: AppColors.ink3),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${n['flashcards']} cards',
                                    style: const TextStyle(fontSize: 11, color: AppColors.ink3),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            n['title'] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            n['summary'] as String,
                            style: const TextStyle(fontSize: 13, color: AppColors.ink2, height: 1.4),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                n['readTime'] as String,
                                style: const TextStyle(fontSize: 12, color: AppColors.ink3),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color: AppColors.ink3,
                              ),
                            ],
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

  Widget _buildToolTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color bg,
    required Color fg,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: fg),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: AppColors.ink3),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
