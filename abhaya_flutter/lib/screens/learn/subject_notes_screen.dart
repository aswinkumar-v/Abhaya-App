import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/abhaya_scaffold.dart';

class SubjectNotesScreen extends StatefulWidget {
  const SubjectNotesScreen({super.key});

  @override
  State<SubjectNotesScreen> createState() => _SubjectNotesScreenState();
}

class _SubjectNotesScreenState extends State<SubjectNotesScreen> {
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return AbhayaScaffold(
      title: '60% read',
      subtitle: 'Heart Chambers & Valves',
      actions: [
        IconButton(
          icon: Icon(
            _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            color: _isBookmarked ? AppColors.teal : AppColors.ink3,
          ),
          onPressed: () {
            setState(() {
              _isBookmarked = !_isBookmarked;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_isBookmarked ? 'Note saved to bookmarks' : 'Removed from bookmarks'),
                duration: const Duration(seconds: 1),
                backgroundColor: AppColors.deep,
              ),
            );
          },
        ),
      ],
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.mint2,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Anatomy & Physiology',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.teal),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.sand,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '6 min read',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.sandInk),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  AppTextStyles.twoToneHeadline(
                    main: 'Heart Anatomy',
                    secondary: 'chambers, valves and flow',
                    fontSize: 24,
                  ),
                  const SizedBox(height: 18),

                  // Core Content Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.line),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.ink.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'The Four Chambers',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'The upper atria receive venous return (right atrium receives deoxygenated blood from the vena cavae, left atrium receives oxygenated blood from pulmonary veins). The lower muscular ventricles pump blood forward. The left ventricle myocardium is 3x thicker than the right due to high systemic vascular resistance.',
                          style: TextStyle(fontSize: 14, color: AppColors.ink2, height: 1.55),
                        ),
                        SizedBox(height: 16),
                        Divider(color: AppColors.line),
                        SizedBox(height: 16),
                        Text(
                          'The Four Heart Valves',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Valves enforce unidirectional blood flow. Atrioventricular (AV) valves include the Tricuspid (right) and Mitral / Bicuspid (left), anchored by chordae tendineae. Semilunar valves include Pulmonic and Aortic, preventing backflow during diastole.',
                          style: TextStyle(fontSize: 14, color: AppColors.ink2, height: 1.55),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Mnemonic Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFBF1D3), Color(0xFFF8E7BC)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFECD58C)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.lightbulb_rounded, color: AppColors.sandInk, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'CLINICAL MNEMONIC: BLOOD FLOW ORDER',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.sandInk,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '"Try Pulling My Aorta"',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Tricuspid → Pulmonic → Mitral → Aortic.',
                                style: TextStyle(fontSize: 13, color: AppColors.ink2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // On the Ward Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'On The Ward: Nursing Assessment',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Heart murmurs originate from turbulent flow across stenotic or regurgitant valves. Auscultate the 5 traditional precordial areas (Aortic, Pulmonic, Erb\'s point, Tricuspid, Mitral) with both bell and diaphragm.',
                          style: TextStyle(fontSize: 13, color: AppColors.ink2, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Floating Bottom Action Dock
            Positioned(
              left: 20,
              right: 20,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.ink.withOpacity(0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDockAction(
                      icon: Icons.psychology_rounded,
                      label: 'Explain Simpler',
                      color: AppColors.teal,
                      onTap: () => Navigator.pushNamed(context, '/chat'),
                    ),
                    _buildDockAction(
                      icon: Icons.style_rounded,
                      label: 'Flashcards',
                      color: AppColors.blushInk,
                      onTap: () => Navigator.pushNamed(context, '/flashcards'),
                    ),
                    _buildDockAction(
                      icon: Icons.quiz_rounded,
                      label: 'Test Me',
                      color: AppColors.lilacInk,
                      onTap: () => Navigator.pushNamed(context, '/exam-question'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDockAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
