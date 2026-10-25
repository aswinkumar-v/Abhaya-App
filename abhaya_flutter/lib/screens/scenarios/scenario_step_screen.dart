import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ScenarioStepScreen extends StatefulWidget {
  const ScenarioStepScreen({super.key});

  @override
  State<ScenarioStepScreen> createState() => _ScenarioStepScreenState();
}

class _ScenarioStepScreenState extends State<ScenarioStepScreen> {
  int? _selectedOpt;
  bool _isChecked = false;
  final int _rightIndex = 0; // ST elevation

  final List<Map<String, dynamic>> _stepList = [
    {
      'title': 'Assess chest pain',
      'sub': 'Onset, radiation, severity 8/10',
      'icon': Icons.favorite_rounded,
    },
    {
      'title': 'Read the ECG',
      'sub': 'You are here',
      'icon': Icons.monitor_heart_rounded,
    },
    {
      'title': 'Give first medication',
      'sub': 'As prescribed',
      'icon': Icons.medication_rounded,
    },
    {
      'title': 'Escalate & document',
      'sub': 'Senior team, notes',
      'icon': Icons.assignment_turned_in_rounded,
    },
  ];

  final List<String> _options = [
    'ST elevation',
    'Prolonged QT interval',
    'Wide QRS complex',
    'Delta waves',
  ];

  @override
  Widget build(BuildContext context) {
    final isCorrect = _selectedOpt == _rightIndex;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: const [
            Text('Acute MI · Case', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
            Text('Decision 2 of 4', style: TextStyle(fontSize: 12, color: AppColors.ink3)),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vitals banner
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF163635), Color(0xFF1F5852)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    _vitalCol('112', 'HR'),
                    _divider(),
                    _vitalCol('160/95', 'BP'),
                    _divider(),
                    _vitalCol('94%', 'SpO₂'),
                    _divider(),
                    _vitalCol('8/10', 'Pain'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Care steps section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Your care steps', style: AppTextStyles.h3),
                  Text(_isChecked ? '2 of 4 done' : '1 of 4 done', style: AppTextStyles.meta),
                ],
              ),
              const SizedBox(height: 12),

              // Stepper column
              Column(
                children: List.generate(_stepList.length, (i) {
                  final step = _stepList[i];
                  final isDone = i < (_isChecked ? 2 : 1);
                  final isCurrent = !_isChecked && i == 1;

                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left indicator & vertical dashed line
                        SizedBox(
                          width: 28,
                          child: Column(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDone ? AppColors.teal : Colors.white,
                                  border: Border.all(
                                    color: isDone || isCurrent ? AppColors.teal : const Color(0xFFC9D6D3),
                                    width: 2,
                                  ),
                                  boxShadow: isCurrent
                                      ? [
                                          BoxShadow(
                                            color: AppColors.teal.withValues(alpha: 0.2),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          )
                                        ]
                                      : null,
                                ),
                                child: isDone
                                    ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                                    : null,
                              ),
                              if (i < _stepList.length - 1)
                                Expanded(
                                  child: Center(
                                    child: Container(
                                      width: 2,
                                      color: const Color(0xFFBFD3CF),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Step content card
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isCurrent ? const Color(0xFFA9DCD0) : const Color(0xFFE6EDEB),
                                width: isCurrent ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: AppColors.track,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(step['icon'] as IconData, size: 18, color: AppColors.ink2),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        step['title'] as String,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        (i == 1 && _isChecked) ? 'ECG reviewed' : step['sub'] as String,
                                        style: const TextStyle(fontSize: 12, color: AppColors.ink3),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),

              // Note box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5F2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.monitor_heart_rounded, color: AppColors.teal, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '12-lead ECG recorded · The doctor asks what you observe.',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Question Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6F0E8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'ECG INTERPRETATION',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.deep),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Which ECG finding would you expect?',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Option radios
              ...List.generate(_options.length, (i) {
                final text = _options[i];
                final isSelected = _selectedOpt == i;
                final isRight = _isChecked && i == _rightIndex;
                final isWrong = _isChecked && isSelected && !isCorrect;

                Color bg = Colors.white;
                Color borderCol = const Color(0xFFE2EBE8);

                if (isRight) {
                  bg = const Color(0xFFEBF7F4);
                  borderCol = const Color(0xFF4FBFAE);
                } else if (isWrong) {
                  bg = const Color(0xFFFDEEEA);
                  borderCol = const Color(0xFFE59A7E);
                } else if (isSelected) {
                  bg = const Color(0xFFEDF8F6);
                  borderCol = AppColors.teal;
                }

                return GestureDetector(
                  onTap: () {
                    if (!_isChecked) {
                      setState(() => _selectedOpt = i);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderCol, width: isSelected || isRight || isWrong ? 1.5 : 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? AppColors.teal : AppColors.track,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'ABCD'[i],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : AppColors.ink,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // Rationale feedback card
              if (_isChecked) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isCorrect ? const Color(0xFFEBF7F4) : const Color(0xFFFDEEEA),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isCorrect ? Icons.check_rounded : Icons.close_rounded,
                          color: isCorrect ? const Color(0xFF1D8776) : const Color(0xFFB84B2E),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isCorrect ? 'Right call' : 'Not quite. Expect ST elevation',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isCorrect ? const Color(0xFF1D8776) : const Color(0xFFB84B2E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'KEY RATIONALE',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.ink),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'ST elevation is the hallmark of STEMI: heart muscle is being injured now, so the patient needs urgent reperfusion.',
                              style: TextStyle(fontSize: 12, color: AppColors.ink2, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Action button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _selectedOpt == null
                      ? null
                      : () {
                          if (!_isChecked) {
                            setState(() => _isChecked = true);
                          } else {
                            Navigator.pushNamed(context, '/scenario-complete');
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFDCE6E4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        !_isChecked ? 'Submit decision' : 'Continue',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      if (_isChecked) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vitalCol(String val, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(val, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF9EC2BD))),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 24,
      color: Colors.white.withValues(alpha: 0.16),
    );
  }
}
