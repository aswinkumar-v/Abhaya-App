import 'package:flutter/material.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';

class ExamSetupScreen extends StatefulWidget {
  const ExamSetupScreen({super.key});

  @override
  State<ExamSetupScreen> createState() => _ExamSetupScreenState();
}

class _ExamSetupScreenState extends State<ExamSetupScreen> {
  int _selectedFormat = 0; // 0=MCQ, 1=Short answer, 2=Long answer, 3=Case-based
  int _selectedCount = 10; // 10, 20, 30
  String _selectedSubject = 'Medical-Surgical Nursing I';

  final Map<String, String> _shortNames = {
    'Medical-Surgical Nursing I': 'Med-Surg',
    'Anatomy & Physiology': 'Anatomy',
    'Pharmacology': 'Pharmacology',
  };

  final List<String> _subjects = [
    'Medical-Surgical Nursing I',
    'Anatomy & Physiology',
    'Pharmacology',
  ];

  final List<Map<String, dynamic>> _formats = [
    {
      'title': 'MCQ',
      'subtitle': 'Quick recall',
      'label': 'MCQ',
      'timePerQ': 1,
      'bg': Color(0xFFDCF3EB),
      'activeBorder': Color(0xFF1E6B63),
      'iconColor': Color(0xFF1E6B63),
      'icon': Icons.check_box_outlined,
    },
    {
      'title': 'Short answer',
      'subtitle': '2 and 5 marks',
      'label': 'short answer',
      'timePerQ': 2,
      'bg': Color(0xFFEFE9FA),
      'activeBorder': Color(0xFF7E66C4),
      'iconColor': Color(0xFF7E66C4),
      'icon': Icons.edit_outlined,
    },
    {
      'title': 'Long answer',
      'subtitle': '15 mark essays',
      'label': 'long answer',
      'timePerQ': 5,
      'bg': Color(0xFFE3EFF8),
      'activeBorder': Color(0xFF3B82A6),
      'iconColor': Color(0xFF3B82A6),
      'icon': Icons.notes_rounded,
    },
    {
      'title': 'Case-based',
      'subtitle': 'Patient scenarios',
      'label': 'case-based',
      'timePerQ': 3,
      'bg': Color(0xFFFDEEE9),
      'activeBorder': Color(0xFFD46950),
      'iconColor': Color(0xFFD46950),
      'icon': Icons.monitor_heart_outlined,
    },
  ];

  String _formatDuration(int minutes) {
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final rem = minutes % 60;
      return rem > 0 ? '${hours}h $rem min' : '${hours}h';
    }
    return '$minutes min';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserService.instance,
      builder: (context, _) {
        final user = UserService.instance;
        final curFormat = _formats[_selectedFormat];
        final totalMins = _selectedCount * (curFormat['timePerQ'] as int);
        final durationStr = 'About ${_formatDuration(totalMins)} · pause anytime';
        final buttonLabel = 'Start $_selectedCount-question ${curFormat['label']} test';
        final shortSubj = _shortNames[_selectedSubject] ?? _selectedSubject;

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRoundIconButton(
                        icon: Icons.bar_chart_rounded,
                        onTap: () => Navigator.pushNamed(context, '/progress'),
                        tooltip: 'My progress',
                      ),
                      _buildRoundIconButton(
                        icon: Icons.history_rounded,
                        onTap: () => Navigator.pushNamed(context, '/exam-history'),
                        tooltip: 'Exam history',
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Title Headline
                  const Text(
                    'Ready to ace it',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                      letterSpacing: -0.5,
                      fontFamily: 'Figtree',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$shortSubj · Sem ${user.semester}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF7E908B),
                      letterSpacing: -0.3,
                      fontFamily: 'Figtree',
                    ),
                  ),

              const SizedBox(height: 16),

              // 3 Mini Info Cards Row
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      label: 'Exam',
                      value: '3 Nov',
                      sub: 'Monday',
                      iconColor: const Color(0xFFE38827),
                      icon: Icons.calendar_today_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildInfoCard(
                      label: 'Starts',
                      value: '10:00',
                      sub: '3 hours',
                      iconColor: const Color(0xFFE26D5C),
                      icon: Icons.schedule_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildInfoCard(
                      label: 'Marks',
                      value: '75',
                      sub: '6 units',
                      iconColor: const Color(0xFF886CC0),
                      icon: Icons.assignment_outlined,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Dark Card: Exam Ready
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF132A26),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Exam ready',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'Figtree',
                          ),
                        ),
                        Text(
                          '${user.examReadiness}%',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                            fontFamily: 'Figtree',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Progress track with sparkle thumb
                    LayoutBuilder(
                      builder: (context, constraints) {
                        const trackHeight = 46.0;
                        final ratio = (user.examReadiness / 100.0).clamp(0.0, 1.0);
                        final fillWidth = constraints.maxWidth * ratio;

                        return Container(
                          height: trackHeight,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(trackHeight / 2),
                          ),
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              if (fillWidth > 0)
                                Container(
                                  width: fillWidth,
                                  height: trackHeight,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(trackHeight / 2),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF1F6A62),
                                        Color(0xFF3E9C8E),
                                        Color(0xFF7FCBBB),
                                      ],
                                    ),
                                  ),
                                ),
                              Positioned(
                                left: (fillWidth - 38).clamp(6.0, constraints.maxWidth - 40),
                                child: Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.25),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.auto_awesome,
                                    size: 16,
                                    color: Color(0xFF132A26),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),
                    Text(
                      'Weak spots: ${user.weakSpotsText}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8BAAA3),
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // White Card: Start a mock exam
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE7EDEB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Start a mock exam',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: -0.3,
                        fontFamily: 'Figtree',
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Label: Format
                    const Text(
                      'Format',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink2,
                        fontFamily: 'Figtree',
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 2x2 Format Tiles Grid
                    Row(
                      children: [
                        Expanded(child: _buildFormatTile(0)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildFormatTile(1)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildFormatTile(2)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildFormatTile(3)),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Label: Subject
                    const Text(
                      'Subject',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink2,
                        fontFamily: 'Figtree',
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Subject Dropdown Pill
                    Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: const Color(0xFFE2EAE7), width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF1E6B63),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedSubject,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.ink,
                                  size: 22,
                                ),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                  fontFamily: 'Figtree',
                                ),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedSubject = val);
                                },
                                items: _subjects.map((s) {
                                  return DropdownMenuItem(value: s, child: Text(s));
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Label: Questions
                    const Text(
                      'Questions',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink2,
                        fontFamily: 'Figtree',
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Questions Segmented Control
                    Container(
                      height: 48,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF0EE),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [10, 20, 30].map((count) {
                          final isSelected = count == _selectedCount;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedCount = count),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.05),
                                            blurRadius: 4,
                                            offset: const Offset(0, 1),
                                          ),
                                        ]
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$count',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? AppColors.ink : AppColors.ink2,
                                    fontFamily: 'Figtree',
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Action Button
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/exam-question',
                        arguments: {
                          'subject': _selectedSubject,
                          'format': curFormat['label'],
                          'count': _selectedCount,
                        },
                      ),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22645B),
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF22645B).withValues(alpha: 0.28),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          buttonLabel,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Figtree',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Subtext Duration
                    Center(
                      child: Text(
                        durationStr,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7E908B),
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Predicted Questions Note Banner
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/question-predictor'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F3EF),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          size: 18,
                          color: Color(0xFF1E6B63),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '20 predicted questions are ready',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                                fontFamily: 'Figtree',
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'From your syllabus and 12 past papers',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF5E7972),
                                fontFamily: 'Figtree',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF1E6B63),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card: Score Trend
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/exam-history'),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE7EDEB)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
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
                          const Text(
                            'Score trend',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                              letterSpacing: -0.3,
                              fontFamily: 'Figtree',
                            ),
                          ),
                          Text(
                            user.examHistory.isEmpty ? '0 mocks taken' : 'Last ${user.examHistory.length} mocks',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF7E908B),
                              fontFamily: 'Figtree',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (user.examHistory.isEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7FAF8),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE6EFEA)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEAF5F1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.insights_rounded,
                                  color: Color(0xFF1E6B63),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'No mock exams yet',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                        fontFamily: 'Figtree',
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Take your first test to track your score trend and weak spots.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6F8881),
                                        fontFamily: 'Figtree',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      else ...[
                        // Real Vertical Bars from examHistory
                        SizedBox(
                          height: 150,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: user.examHistory.reversed.take(6).toList().asMap().entries.map((e) {
                              final i = e.key;
                              final exam = e.value;
                              final val = exam.percentage;
                              final isNow = i == (user.examHistory.length > 6 ? 5 : user.examHistory.length - 1);
                              final barHeight = ((val / 100) * 110).clamp(12.0, 110.0);

                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (isNow) ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF132A26),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '$val%',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              fontFamily: 'Figtree',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                      Container(
                                        height: barHeight,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: isNow
                                              ? const Color(0xFF1E6B63)
                                              : const Color(0xFFD3E5E1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '#${i + 1}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: isNow ? FontWeight.w700 : FontWeight.w500,
                                          color: isNow ? AppColors.ink : const Color(0xFF7E908B),
                                          fontFamily: 'Figtree',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }

  Widget _buildRoundIconButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE6ECEA)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, size: 20, color: AppColors.ink),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String label,
    required String value,
    required String sub,
    required Color iconColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7EDEB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ink2,
                  fontFamily: 'Figtree',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              letterSpacing: -0.5,
              fontFamily: 'Figtree',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF7E908B),
              fontFamily: 'Figtree',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatTile(int index) {
    final format = _formats[index];
    final isSelected = index == _selectedFormat;

    return GestureDetector(
      onTap: () => setState(() => _selectedFormat = index),
      child: Container(
        height: 116,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: format['bg'] as Color,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: format['activeBorder'] as Color, width: 1.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative background circle
            Positioned(
              right: -15,
              bottom: -20,
              child: Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      format['icon'] as IconData,
                      size: 18,
                      color: format['iconColor'] as Color,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  format['title'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    letterSpacing: -0.2,
                    fontFamily: 'Figtree',
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  format['subtitle'] as String,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.ink2,
                    fontFamily: 'Figtree',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
