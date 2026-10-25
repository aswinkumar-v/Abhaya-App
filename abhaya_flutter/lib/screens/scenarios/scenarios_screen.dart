import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/abhaya_scaffold.dart';
import '../../core/widgets/pill_button.dart';

class ScenariosScreen extends StatefulWidget {
  const ScenariosScreen({super.key});

  @override
  State<ScenariosScreen> createState() => _ScenariosScreenState();
}

class _ScenariosScreenState extends State<ScenariosScreen> {
  int _selectedCat = 0;

  final List<String> _categories = ['All', 'Cardiac', 'Respiratory', 'Renal', 'Pediatric', 'OBG'];

  final List<Map<String, dynamic>> _cases = [
    {
      'patient': 'Mr. Raj, 58',
      'location': 'Emergency Dept',
      'condition': 'Acute MI',
      'vitals': 'HR 112 · SpO₂ 94%',
      'difficulty': 'Hard',
      'aiGuided': true,
      'category': 'Cardiac',
      'color': AppColors.teal,
      'bgColor': const Color(0xFF1B4A44),
    },
    {
      'patient': 'Mrs. Meera, 42',
      'location': 'Medical Ward',
      'condition': 'Pneumonia',
      'vitals': 'RR 26 · SpO₂ 91%',
      'difficulty': 'Medium',
      'aiGuided': false,
      'category': 'Respiratory',
      'color': const Color(0xFF8A7FCA),
      'bgColor': Colors.white,
    },
    {
      'patient': 'Baby Arjun, 6mo',
      'location': 'Paediatric ICU',
      'condition': 'Febrile Seizure',
      'vitals': 'Temp 39.2°C · HR 148',
      'difficulty': 'Medium',
      'aiGuided': false,
      'category': 'Pediatric',
      'color': const Color(0xFFE07B8B),
      'bgColor': Colors.white,
    },
    {
      'patient': 'Mr. Krishnan, 67',
      'location': 'Dialysis Unit',
      'condition': 'CKD Stage 5',
      'vitals': 'BP 168/98 · K⁺ 5.8',
      'difficulty': 'Hard',
      'aiGuided': false,
      'category': 'Renal',
      'color': const Color(0xFFD4956A),
      'bgColor': Colors.white,
    },
    {
      'patient': 'Mrs. Priya, 29',
      'location': 'Labour Room',
      'condition': 'Pre-eclampsia',
      'vitals': 'BP 148/95 · Proteinuria +3',
      'difficulty': 'Hard',
      'aiGuided': true,
      'category': 'OBG',
      'color': const Color(0xFF4DB39E),
      'bgColor': Colors.white,
    },
    {
      'patient': 'Mr. Suresh, 45',
      'location': 'Surgical Ward',
      'condition': 'Post-Op Care',
      'vitals': 'Wound drain 80mL · Pain 6/10',
      'difficulty': 'Easy',
      'aiGuided': false,
      'category': 'Cardiac',
      'color': const Color(0xFF6BBFB0),
      'bgColor': Colors.white,
    },
  ];

  List<Map<String, dynamic>> get _filteredCases {
    if (_selectedCat == 0) return _cases;
    final cat = _categories[_selectedCat];
    return _cases.where((c) => c['category'] == cat).toList();
  }

  @override
  Widget build(BuildContext context) {
    final featured = _cases[0];

    return AbhayaScaffold(
      showBack: false,
      title: 'Clinical Scenarios',
      subtitle: 'Practice ward-side decisions',
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: AppTextStyles.twoToneHeadline(
                  main: 'Practise smarter',
                  secondary: "like you're on the ward",
                  fontSize: 22,
                ),
              ),

              // Featured Teal Card
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/scenario-detail'),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  height: 210,
                  decoration: BoxDecoration(
                    color: AppColors.deep,
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF163635), Color(0xFF1D4E48)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Patient Info box
                      Positioned(
                        left: 20,
                        top: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _patientInfoRow(Icons.person_outline_rounded, featured['patient']),
                            const SizedBox(height: 8),
                            _patientInfoRow(Icons.location_on_outlined, featured['location']),
                            const SizedBox(height: 8),
                            _patientInfoRow(Icons.monitor_heart_outlined, featured['condition']),
                          ],
                        ),
                      ),

                      // Monitor widget
                      Positioned(
                        right: 16,
                        bottom: 28,
                        child: Container(
                          width: 130,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF16393A),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF22504D), width: 2.5),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 20)],
                          ),
                          child: Column(
                            children: [
                              // ECG line
                              SizedBox(
                                height: 30,
                                child: CustomPaint(painter: _EcgPainter()),
                              ),
                              const SizedBox(height: 6),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('HR 112', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                                  Text('SpO₂ 94%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFF5D985))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // AI badge
                      Positioned(
                        left: 20,
                        bottom: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD6F0E8),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.auto_awesome_rounded, size: 14, color: AppColors.deep),
                              SizedBox(width: 6),
                              Text('AI-guided case', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.deep)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Random scenario
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/scenario-detail'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEEDE8),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFECC4B0)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.shuffle_rounded, color: Color(0xFFD4956A), size: 22),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Random Scenario', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.ink)),
                              Text('A surprise case from your subjects', style: TextStyle(fontSize: 12, color: AppColors.ink3)),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.ink3),
                      ],
                    ),
                  ),
                ),
              ),

              // Category Filters
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 8),
                child: Text('Clinical Cases', style: AppTextStyles.h3),
              ),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemCount: _categories.length,
                  itemBuilder: (context, i) {
                    final selected = _selectedCat == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCat = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.teal : AppColors.track,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            _categories[i],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: selected ? Colors.white : AppColors.ink2,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Cases List
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  children: _filteredCases.asMap().entries.map((entry) {
                    final i = entry.key;
                    final c = entry.value;
                    final isLast = i == _filteredCases.length - 1;

                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/scenario-detail'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          border: isLast ? null : const Border(
                            bottom: BorderSide(color: AppColors.line),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: (c['color'] as Color).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(Icons.local_hospital_outlined, color: c['color'] as Color, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c['patient'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.ink)),
                                  const SizedBox(height: 2),
                                  Text(c['condition'] as String, style: const TextStyle(fontSize: 12, color: AppColors.ink3)),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.track,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(c['vitals'] as String, style: const TextStyle(fontSize: 10, color: AppColors.ink2, fontWeight: FontWeight.w600)),
                                      ),
                                      const SizedBox(width: 8),
                                      _difficultyBadge(c['difficulty'] as String),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.ink3),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _patientInfoRow(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white.withOpacity(0.85)),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.9))),
        ],
      ),
    );
  }

  Widget _difficultyBadge(String diff) {
    final Color color;
    switch (diff) {
      case 'Easy':
        color = AppColors.teal;
        break;
      case 'Medium':
        color = const Color(0xFFD4956A);
        break;
      default:
        color = const Color(0xFFE07B8B);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(diff, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w700)),
    );
  }
}

class _EcgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7FE0C8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final pts = [
      Offset(0, size.height * 0.65),
      Offset(size.width * 0.25, size.height * 0.65),
      Offset(size.width * 0.30, size.height * 0.65 - 8),
      Offset(size.width * 0.35, size.height * 0.65 + 5),
      Offset(size.width * 0.40, size.height * 0.65 - 20),
      Offset(size.width * 0.45, size.height * 0.65 + 12),
      Offset(size.width * 0.50, size.height * 0.65 - 3),
      Offset(size.width * 0.60, size.height * 0.65),
      Offset(size.width * 0.70, size.height * 0.65 - 5),
      Offset(size.width * 0.75, size.height * 0.65 + 3),
      Offset(size.width * 1.0, size.height * 0.65),
    ];

    path.moveTo(pts[0].dx, pts[0].dy);
    for (final pt in pts.skip(1)) {
      path.lineTo(pt.dx, pt.dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
