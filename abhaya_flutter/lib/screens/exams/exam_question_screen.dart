import 'package:flutter/material.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ExamQuestionScreen extends StatefulWidget {
  const ExamQuestionScreen({super.key});

  @override
  State<ExamQuestionScreen> createState() => _ExamQuestionScreenState();
}

class _ExamQuestionScreenState extends State<ExamQuestionScreen> {
  int _questionIndex = 0;
  int? _selectedOption;
  bool _isChecked = false;
  bool _isBookmarked = false;
  final List<bool> _history = [];
  final List<String> _missedTags = [];
  final List<Map<String, dynamic>> _reviewedQuestions = [];

  String _subject = 'Medical-Surgical Nursing I';
  String _format = 'MCQ';
  int _totalCount = 10;
  bool _initializedArgs = false;

  final List<Map<String, dynamic>> _questionBank = [
    {
      'tag': 'Cardiology',
      'question': 'A patient with acute MI arrives. Which medication is usually given first?',
      'options': ['Morphine', 'Aspirin', 'IV fluids', 'Furosemide'],
      'rightIndex': 1,
      'explanation': 'Aspirin stops platelets clumping, so the clot stops growing. It is first-line in AMI.',
    },
    {
      'tag': 'Renal care',
      'question': 'Which ECG change is an early sign of hyperkalaemia?',
      'options': ['Tall peaked T waves', 'ST depression', 'Prolonged PR only', 'U waves'],
      'rightIndex': 0,
      'explanation': 'High potassium makes T waves tall and peaked before other changes appear.',
    },
    {
      'tag': 'Fluids & electrolytes',
      'question': 'Which IV fluid is isotonic?',
      'options': ['0.45% saline', '5% dextrose in 0.45% saline', '0.9% saline', '3% saline'],
      'rightIndex': 2,
      'explanation': '0.9% saline has about the same tonicity as plasma, so it stays in the vessels.',
    },
    {
      'tag': 'Respiratory',
      'question': 'In acute asthma, which drug acts fastest to open the airways?',
      'options': ['Inhaled salbutamol', 'Oral prednisolone', 'Montelukast', 'Theophylline'],
      'rightIndex': 0,
      'explanation': 'Short-acting beta-2 agonists relax airway muscle within minutes.',
    },
    {
      'tag': 'Pharmacology',
      'question': 'Which antidote is administered for heparin overdose?',
      'options': ['Protamine sulfate', 'Vitamin K', 'Naloxone', 'Flumazenil'],
      'rightIndex': 0,
      'explanation': 'Protamine sulfate neutralizes heparin rapidly through ionic binding.',
    },
    {
      'tag': 'Neurology',
      'question': 'What is the highest possible score on the Glasgow Coma Scale (GCS)?',
      'options': ['10', '12', '14', '15'],
      'rightIndex': 3,
      'explanation': 'GCS evaluates Eye (4), Verbal (5), and Motor (6) responses, total 15.',
    },
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initializedArgs) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _subject = args['subject'] as String? ?? _subject;
        _format = args['format'] as String? ?? _format;
        _totalCount = args['count'] as int? ?? _totalCount;
      }
      _initializedArgs = true;
    }
  }

  void _checkAnswer() {
    if (_selectedOption == null) return;
    setState(() {
      _isChecked = true;
    });
  }

  void _finishExam() {
    final curQ = _questionBank[_questionIndex % _questionBank.length];
    if (_selectedOption != null) {
      final isCorrect = _selectedOption == curQ['rightIndex'];
      _history.add(isCorrect);
      _reviewedQuestions.add({
        'title': curQ['question'],
        'correct': isCorrect,
        'tag': curQ['tag'],
      });
      if (!isCorrect) {
        _missedTags.add(curQ['tag'] as String);
      }
    }

    final score = _history.where((c) => c).length;
    final total = _history.isEmpty ? 1 : _history.length;

    UserService.instance.recordExamResult(
      subject: _subject,
      format: _format,
      score: score,
      total: total,
      missedTags: _missedTags,
    );

    Navigator.pushReplacementNamed(
      context,
      '/exam-result',
      arguments: {
        'subject': _subject,
        'format': _format,
        'score': score,
        'total': total,
        'history': _history,
        'reviewedQuestions': _reviewedQuestions,
      },
    );
  }

  void _nextQuestion() {
    final curQ = _questionBank[_questionIndex % _questionBank.length];
    final isCorrect = _selectedOption == curQ['rightIndex'];

    _history.add(isCorrect);
    _reviewedQuestions.add({
      'title': curQ['question'],
      'correct': isCorrect,
      'tag': curQ['tag'],
    });
    if (!isCorrect) {
      _missedTags.add(curQ['tag'] as String);
    }

    if (_questionIndex >= (_totalCount - 1)) {
      final score = _history.where((c) => c).length;
      final total = _history.length;

      UserService.instance.recordExamResult(
        subject: _subject,
        format: _format,
        score: score,
        total: total,
        missedTags: _missedTags,
      );

      Navigator.pushReplacementNamed(
        context,
        '/exam-result',
        arguments: {
          'subject': _subject,
          'format': _format,
          'score': score,
          'total': total,
          'history': _history,
          'reviewedQuestions': _reviewedQuestions,
        },
      );
      return;
    }

    setState(() {
      _questionIndex++;
      _selectedOption = null;
      _isChecked = false;
      _isBookmarked = false;
    });
  }

  void _showEndExamDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final currentDone = _history.length + (_isChecked ? 1 : 0);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('End exam?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.ink)),
              const SizedBox(height: 8),
              Text(
                "You've answered $currentDone of $_totalCount. We'll score what you've done so far.",
                style: const TextStyle(fontSize: 14, color: AppColors.ink2),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFD0D7D5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Keep going', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _finishExam();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deep,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('End exam', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final curQ = _questionBank[_questionIndex % _questionBank.length];
    final isCorrect = _isChecked && _selectedOption == curQ['rightIndex'];

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.ink),
          onPressed: _showEndExamDialog,
        ),
        title: Column(
          children: [
            Text(
              '$_subject · $_format',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink),
            ),
            Text(
              'Question ${_questionIndex + 1} of $_totalCount',
              style: const TextStyle(fontSize: 12, color: AppColors.ink3, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2EBE8)),
            ),
            child: Row(
              children: const [
                Icon(Icons.timer_outlined, size: 14, color: AppColors.ink),
                SizedBox(width: 4),
                Text('6:42', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink)),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Segmented dashes progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: List.generate(_totalCount, (i) {
                  Color c = const Color(0xFFE6ECEA);
                  if (i < _history.length) {
                    c = _history[i] ? const Color(0xFF4FBFAE) : const Color(0xFFE59A7E);
                  } else if (i == _questionIndex) {
                    c = _isChecked
                        ? (isCorrect ? const Color(0xFF4FBFAE) : const Color(0xFFE59A7E))
                        : AppColors.deep;
                  }
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: i < (_totalCount - 1) ? 4 : 0),
                      height: 5,
                      decoration: BoxDecoration(
                        color: c,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  );
                }),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1EDF3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              curQ['tag'],
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF386C86),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            curQ['question'],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink,
                              height: 1.4,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Options
                    ...List.generate(curQ['options'].length, (i) {
                      final optText = curQ['options'][i];
                      final isSelected = _selectedOption == i;
                      final isRight = _isChecked && i == curQ['rightIndex'];
                      final isWrong = _isChecked && isSelected && !isCorrect;

                      Color bg = Colors.white;
                      Color borderCol = const Color(0xFFE2EBE8);
                      Color letterBg = AppColors.track;
                      Color letterCol = AppColors.ink;

                      if (isRight) {
                        bg = const Color(0xFFE8F7F4);
                        borderCol = const Color(0xFF4FBFAE);
                        letterBg = const Color(0xFF4FBFAE);
                        letterCol = Colors.white;
                      } else if (isWrong) {
                        bg = const Color(0xFFFDECE8);
                        borderCol = const Color(0xFFE59A7E);
                        letterBg = const Color(0xFFE59A7E);
                        letterCol = Colors.white;
                      } else if (isSelected) {
                        bg = const Color(0xFFEDF8F6);
                        borderCol = AppColors.teal;
                        letterBg = AppColors.teal;
                        letterCol = Colors.white;
                      }

                      return GestureDetector(
                        onTap: () {
                          if (!_isChecked) {
                            setState(() => _selectedOption = i);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: borderCol, width: isSelected || isRight || isWrong ? 1.5 : 1),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: letterBg,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'ABCD'[i],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: letterCol,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  optText,
                                  style: TextStyle(
                                    fontSize: 15,
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

                    // Feedback rationale card
                    if (_isChecked) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isCorrect ? const Color(0xFFEBF7F4) : const Color(0xFFFDEEEA),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isCorrect
                                  ? 'Correct, well done'
                                  : 'Not quite. The answer is ${curQ['options'][curQ['rightIndex']]}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isCorrect ? const Color(0xFF1D8776) : const Color(0xFFB84B2E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              curQ['explanation'],
                              style: const TextStyle(fontSize: 13, color: AppColors.ink2, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom action row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isBookmarked = !_isBookmarked),
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isBookmarked ? AppColors.deep : Colors.white,
                        border: Border.all(color: const Color(0xFFE2EBE8)),
                      ),
                      child: Icon(
                        _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                        color: _isBookmarked ? Colors.white : AppColors.ink,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _selectedOption == null
                            ? null
                            : (_isChecked ? _nextQuestion : _checkAnswer),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.teal,
                          disabledBackgroundColor: const Color(0xFFDCE6E4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              !_isChecked
                                  ? 'Check answer'
                                  : (_questionIndex >= (_totalCount - 1) ? 'See results' : 'Next question'),
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                            if (_isChecked) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
