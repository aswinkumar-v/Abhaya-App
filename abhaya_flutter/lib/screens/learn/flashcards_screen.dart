import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/abhaya_scaffold.dart';
import '../../core/widgets/pill_button.dart';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;

  final List<Map<String, String>> _cards = [
    {
      'topic': 'Cardiovascular System',
      'front': 'What is the primary pacemaker of the human heart, and what is its intrinsic firing rate?',
      'back': 'The Sinoatrial (SA) Node located in the upper wall of the right atrium. Intrinsic firing rate: 60–100 beats per minute.',
    },
    {
      'topic': 'Pharmacology',
      'front': 'Which antidote is administered for Heparin toxicity?',
      'back': 'Protamine Sulfate (1 mg neutralizes approximately 100 units of heparin).',
    },
    {
      'topic': 'Clinical Triage',
      'front': 'What are the classic symptoms in Virchow\'s Triad for DVT formation?',
      'back': '1. Stasis of blood flow\n2. Endothelial injury\n3. Hypercoagulability of blood.',
    },
    {
      'topic': 'Fluid & Electrolytes',
      'front': 'What characteristic ECG change is first observed in hyperkalemia (K+ > 5.5 mEq/L)?',
      'back': 'Tall, peaked, symmetrical T waves with a narrow base, followed by prolonged PR interval and flattened P waves.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentCard = _cards[_currentIndex];

    return AbhayaScaffold(
      title: 'Flashcards',
      subtitle: '${_currentIndex + 1} of ${_cards.length} cards',
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / _cards.length,
                  minHeight: 6,
                  backgroundColor: AppColors.track,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.teal),
                ),
              ),
              const SizedBox(height: 24),

              // Interactive Flip Flashcard
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _showAnswer = !_showAnswer),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: _showAnswer ? const Color(0xFFEAF5F1) : Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: _showAnswer ? const Color(0xFFBFE3D9) : AppColors.line,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.ink.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _showAnswer ? AppColors.teal : AppColors.track,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _showAnswer ? 'ANSWER' : 'QUESTION',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                  color: _showAnswer ? Colors.white : AppColors.ink3,
                                ),
                              ),
                            ),
                            Text(
                              currentCard['topic']!,
                              style: const TextStyle(fontSize: 12, color: AppColors.ink3),
                            ),
                          ],
                        ),
                        Center(
                          child: Text(
                            _showAnswer ? currentCard['back']! : currentCard['front']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: _showAnswer ? 17 : 20,
                              fontWeight: FontWeight.w600,
                              height: 1.45,
                              color: _showAnswer ? AppColors.teal : AppColors.ink,
                            ),
                          ),
                        ),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.touch_app_rounded, size: 16, color: AppColors.ink3),
                              SizedBox(width: 6),
                              Text(
                                'Tap to flip card',
                                style: TextStyle(fontSize: 12, color: AppColors.ink3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Bottom control buttons
              Row(
                children: [
                  Expanded(
                    child: PillButton(
                      text: 'Still Learning',
                      isPrimary: false,
                      isOutline: true,
                      height: 52,
                      textColor: AppColors.bad,
                      onTap: () {
                        setState(() {
                          _showAnswer = false;
                          _currentIndex = (_currentIndex + 1) % _cards.length;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: PillButton(
                      text: 'Got It!',
                      height: 52,
                      backgroundColor: AppColors.teal,
                      onTap: () {
                        setState(() {
                          _showAnswer = false;
                          _currentIndex = (_currentIndex + 1) % _cards.length;
                        });
                      },
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
