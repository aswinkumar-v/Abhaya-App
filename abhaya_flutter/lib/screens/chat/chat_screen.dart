import 'package:flutter/material.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';

class ChatScreen extends StatefulWidget {
  final String? character;
  final String? mode;
  final String? scenario;

  const ChatScreen({
    super.key,
    this.character,
    this.mode,
    this.scenario,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late String _teacher;
  late String _mode;
  late String _scenario;

  bool _isRecording = false;

  final List<_ChatMessage> _messages = [];
  List<String> _currentSuggestions = [];

  @override
  void initState() {
    super.initState();
    _teacher = widget.character ?? 'Dr. Meera Nair';
    _mode = widget.mode ?? 'Story mode';
    _scenario = widget.scenario ?? 'Learn a topic';
    _initializeChat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      bool changed = false;
      if (args['character'] != null && args['character'] != _teacher) {
        _teacher = args['character'] as String;
        changed = true;
      }
      if (args['mode'] != null && args['mode'] != _mode) {
        _mode = args['mode'] as String;
        changed = true;
      }
      if (args['scenario'] != null && args['scenario'] != _scenario) {
        _scenario = args['scenario'] as String;
        changed = true;
      }
      if (changed && _messages.isEmpty) {
        _initializeChat();
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeChat() {
    _messages.clear();

    final userName = UserService.instance.greetingName;

    switch (_scenario) {
      case 'Viva and exam prep':
        _messages.add(_ChatMessage(
          isUser: false,
          text: 'Hi $userName! Welcome to your viva exam prep with $_teacher ($_mode).\n\nI will be your clinical examiner today. Which station or subject shall we begin with?',
        ));
        _currentSuggestions = [
          'Acute Myocardial Infarction',
          'Diabetic Ketoacidosis (DKA)',
          'Septic Shock Protocol',
        ];
        break;

      case 'Discuss a patient case':
        _messages.add(_ChatMessage(
          isUser: false,
          text: 'Hi $userName. Let\'s walk through an acute clinical case together in $_mode.\n\nMr. Raj, 58, presents with crushing chest pain spreading to his left arm. He\'s sweaty and anxious.\n\nWhat do you want to assess first?',
        ));
        _currentSuggestions = [
          'His vitals and an ECG?',
          'Assess pain score (PQRST)',
          'Check blood glucose & IV access',
        ];
        break;

      case 'Clear a doubt':
        _messages.add(_ChatMessage(
          isUser: false,
          text: 'Hi $userName! I\'m $_teacher. Doubts are where real nursing expertise begins. What clinical concept or medication doubt can I clear for you today?',
        ));
        _currentSuggestions = [
          'Why caution Nitroglycerin in Inferior MI?',
          'Acute Myocardial Infarction',
          'Difference between STEMI and NSTEMI',
        ];
        break;

      case 'Surprise me':
        _messages.add(_ChatMessage(
          isUser: false,
          text: 'Hi $userName! Here is your surprise emergency case today.\n\nA 58-year-old male, Mr. Raj, arrives clutching his chest with pain radiating to his left arm. He is pale and diaphoretic.\n\nWhat do you want to know first?',
        ));
        _currentSuggestions = [
          'His vitals and an ECG?',
          'Check vitals & oxygen saturation',
          'Give me a hint',
        ];
        break;

      case 'Learn a topic':
      default:
        _messages.add(_ChatMessage(
          isUser: false,
          text: 'Hi $userName. Let\'s learn clinical practice in $_mode with $_teacher.\n\nWhat concept or disease condition would you like to explore today?',
        ));
        _currentSuggestions = [
          'Acute Myocardial Infarction',
          'Diabetic Ketoacidosis (DKA)',
          'Septic Shock Protocol',
          'Heart Failure & Diuretics',
        ];
        break;
    }
  }

  void _handleSendMessage([String? presetText]) {
    final text = presetText ?? _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(
        isUser: true,
        text: text,
      ));
      _textController.clear();
      _isRecording = false;
      _currentSuggestions = [];
    });

    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _processAiResponse(text);
    });
  }

  void _processAiResponse(String input) {
    final lower = input.toLowerCase();

    // 1. If asking about ECG, Vitals, or Acute MI
    if (lower.contains('ecg') ||
        lower.contains('vital') ||
        lower.contains('infarction') ||
        lower.contains('chest pain') ||
        lower.contains('acute mi') ||
        lower.contains('learn a topic') ||
        lower.contains('stemi')) {
      setState(() {
        _messages.add(_ChatMessage(
          isUser: false,
          richCard: _RichCardData(
            tag: 'Patient case',
            leadText: 'Exactly. His ECG shows ',
            boldKeyword: 'ST elevation',
            trailingLeadText: ' in II, III and aVF.',
            kpTitle: 'Key point',
            kpLeftBig: 'ST ↑',
            kpLeftSmall: 'II · III · aVF',
            kpSign: '=',
            kpRightBig: 'Injury now',
            kpRightSmall: 'time is muscle',
            analogyText: 'Think of a kinked garden hose. The longer it stays blocked, the more plants downstream wilt.',
            detailedNote: 'II, III and aVF look at the inferior wall of the heart, usually supplied by the Right Coronary Artery (RCA).',
            questionText: 'Which medication would you give first?',
          ),
        ));
        _currentSuggestions = [
          'Aspirin',
          'Morphine',
          'Give me a hint',
        ];
      });
    }
    // 2. If user answers Aspirin
    else if (lower.contains('aspirin')) {
      setState(() {
        _messages.add(_ChatMessage(
          isUser: false,
          text: 'Yes! Aspirin first. It stops platelets clumping so the clot doesn’t grow. What would you monitor next?',
        ));
        _currentSuggestions = [
          'Check blood pressure before Nitroglycerin',
          'Alert Cardiac Cath Lab for Primary PCI',
          'Give me a hint',
        ];
      });
    }
    // 3. If user answers Morphine
    else if (lower.contains('morphine')) {
      setState(() {
        _messages.add(_ChatMessage(
          isUser: false,
          text: 'Morphine effectively relieves severe chest pain and autonomic anxiety, but always check respiratory rate and BP first! Remember antiplatelet therapy (Aspirin) is the urgent first drug to limit thrombosis.',
        ));
        _currentSuggestions = [
          'Administer Aspirin 325 mg (chewed)',
          'Check BP before Nitroglycerin',
          'Give me a hint',
        ];
      });
    }
    // 4. If user requests hint
    else if (lower.contains('hint')) {
      setState(() {
        _messages.add(_ChatMessage(
          isUser: false,
          text: 'Clinical Hint: Think of the fast-acting antiplatelet agent chewed immediately in acute coronary syndrome to prevent thrombus propagation.',
        ));
        _currentSuggestions = [
          'Aspirin',
          'Morphine',
          'Nitroglycerin',
        ];
      });
    }
    // 5. DKA Topic
    else if (lower.contains('dka') || lower.contains('ketoacidosis') || lower.contains('glucose')) {
      setState(() {
        _messages.add(_ChatMessage(
          isUser: false,
          richCard: _RichCardData(
            tag: 'Endocrine case',
            leadText: 'In DKA, profound insulin deficiency causes severe lipolysis and ',
            boldKeyword: 'metabolic acidosis',
            trailingLeadText: ' with high anion gap.',
            kpTitle: 'Key point',
            kpLeftBig: 'Anion Gap ↑',
            kpLeftSmall: 'Ketones in urine/blood',
            kpSign: '=',
            kpRightBig: 'Insulin + IV fluids',
            kpRightSmall: 'close the gap',
            analogyText: 'Think of cells starving in a sea of sugar: without the insulin key, glucose cannot enter cells.',
            detailedNote: 'Always ensure Potassium is > 3.3 mEq/L before starting an insulin infusion to prevent fatal arrhythmias.',
            questionText: 'What is the immediate first-line IV fluid administered in DKA?',
          ),
        ));
        _currentSuggestions = [
          '0.9% Normal Saline (1-1.5 L in first hour)',
          'Check serum Potassium first',
          'Give me a hint',
        ];
      });
    }
    // 6. Sepsis Topic
    else if (lower.contains('sepsis') || lower.contains('shock') || lower.contains('lactate')) {
      setState(() {
        _messages.add(_ChatMessage(
          isUser: false,
          richCard: _RichCardData(
            tag: 'Critical care',
            leadText: 'The Surviving Sepsis Campaign prioritizes the 1-hour bundle to prevent ',
            boldKeyword: 'tissue hypoperfusion',
            trailingLeadText: ' and end-organ dysfunction.',
            kpTitle: 'Key point',
            kpLeftBig: 'Lactate > 2',
            kpLeftSmall: 'MAP < 65 mmHg',
            kpSign: '=',
            kpRightBig: '30 mL/kg IV',
            kpRightSmall: 'hour-1 bundle',
            analogyText: 'Think of systemic vasodilation as expanded pipes: the pressure drops until you refill the circulatory volume.',
            detailedNote: 'Draw blood cultures prior to administering broad-spectrum antimicrobials, but never delay antibiotics over 1 hour.',
            questionText: 'Which vasopressor is first-line if hypotension persists after fluid resuscitation?',
          ),
        ));
        _currentSuggestions = [
          'Norepinephrine',
          'Dopamine',
          'Give me a hint',
        ];
      });
    }
    // 7. General Clinical Response
    else {
      setState(() {
        _messages.add(_ChatMessage(
          isUser: false,
          text: 'Great clinical question! In $_mode, we approach this by prioritizing patient safety and evidence-based nursing interventions.\n\nWould you like to examine the pathophysiology or jump straight into the emergency management protocol?',
        ));
        _currentSuggestions = [
          'Acute Myocardial Infarction',
          'Review Emergency Management',
          'Give me a hint',
        ];
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 350,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFCFB),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildTopAppBar(),

            // Chat Scrollable Feed
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Scenario Context & Date
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Text(
                          '$_scenario · Today',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF7E9592),
                            fontFamily: 'Figtree',
                          ),
                        ),
                      ),
                    ),

                    // Message Stream
                    ..._messages.map((msg) {
                      if (msg.isUser) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _buildUserBubble(msg.text ?? ''),
                        );
                      } else if (msg.richCard != null) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _buildRichCardWidget(msg.richCard!),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _buildDoctorBubble(msg.text ?? ''),
                        );
                      }
                    }),

                    // Quick Suggestion Pills
                    if (_currentSuggestions.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      ..._currentSuggestions.map((sug) => _buildSuggestionPill(sug)),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ),

            // Composer Input Bar at Bottom
            _buildComposerBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Circular Back Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
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
              child: const Center(
                child: Icon(
                  Icons.chevron_left_rounded,
                  size: 24,
                  color: AppColors.ink,
                ),
              ),
            ),
          ),

          // Center: Teacher Name & Mode with Change Link
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _teacher,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF12302E),
                  letterSpacing: -0.3,
                  fontFamily: 'Figtree',
                ),
              ),
              const SizedBox(height: 2),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/choose-mode',
                    arguments: {'scenario': _scenario},
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF3FB39E),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '$_mode · change',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E6B63),
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Circular More Options Button
          GestureDetector(
            onTap: _showMoreOptions,
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
              child: const Center(
                child: Icon(
                  Icons.more_horiz_rounded,
                  size: 22,
                  color: AppColors.ink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorBubble(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(22),
            bottomLeft: Radius.circular(22),
            bottomRight: Radius.circular(22),
          ),
          border: Border.all(color: const Color(0xFFE6ECEA)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14.5,
            height: 1.5,
            color: Color(0xFF12302E),
            fontWeight: FontWeight.w400,
            fontFamily: 'Figtree',
          ),
        ),
      ),
    );
  }

  Widget _buildUserBubble(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: const BoxDecoration(
          color: Color(0xFF163E3A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(22),
            bottomRight: Radius.circular(22),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x22163E3A),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14.5,
            height: 1.4,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'Figtree',
          ),
        ),
      ),
    );
  }

  Widget _buildRichCardWidget(_RichCardData card) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE6ECEA)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row: Tag & Length Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  card.tag,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A6B5B),
                    fontFamily: 'Figtree',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    _buildSegmentButton(
                      label: 'Short',
                      isSelected: !card.isDetailed,
                      onTap: () => setState(() => card.isDetailed = false),
                    ),
                    _buildSegmentButton(
                      label: 'Detailed',
                      isSelected: card.isDetailed,
                      onTap: () => setState(() => card.isDetailed = true),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Primary Clinical Statement with Bold Highlight
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Color(0xFF12302E),
                fontFamily: 'Figtree',
              ),
              children: [
                TextSpan(text: card.leadText),
                TextSpan(
                  text: card.boldKeyword,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: card.trailingLeadText),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Key Point Banner (.kp)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2C7E73),
                  Color(0xFF1A5650),
                  Color(0xFF143E3C),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A5650).withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  card.kpTitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xB8FFFFFF),
                    fontFamily: 'Figtree',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.kpLeftBig,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.4,
                            fontFamily: 'Figtree',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          card.kpLeftSmall,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xB8FFFFFF),
                            fontFamily: 'Figtree',
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        card.kpSign,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xB3FFFFFF),
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          card.kpRightBig,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.3,
                            fontFamily: 'Figtree',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          card.kpRightSmall,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xB8FFFFFF),
                            fontFamily: 'Figtree',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Analogy Callout Box (.an)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFBF1D3),
                  Color(0xFFF8E7BC),
                ],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: Color(0xFF8A6A12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    card.analogyText,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF1E2926),
                      fontFamily: 'Figtree',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Detailed expansion note
          if (card.isDetailed && card.detailedNote != null) ...[
            const SizedBox(height: 10),
            Text(
              card.detailedNote!,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: Color(0xFF7E9592),
                fontFamily: 'Figtree',
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Question Prompt
          Text(
            card.questionText,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF12302E),
              fontFamily: 'Figtree',
            ),
          ),

          const SizedBox(height: 14),

          // Action Buttons: Save note, Quiz me, Listen
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildActionButton(
                icon: card.saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                label: card.saved ? 'Saved' : 'Save note',
                bgColor: const Color(0xFFD7EEE8),
                textColor: const Color(0xFF1E6B63),
                onTap: () {
                  setState(() => card.saved = !card.saved);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(card.saved ? 'Saved to your notes.' : 'Removed from notes.'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              _buildActionButton(
                icon: Icons.check_box_outlined,
                label: 'Quiz me',
                bgColor: const Color(0xFFDCEBF1),
                textColor: const Color(0xFF2D6383),
                onTap: () => _handleSendMessage('Quiz me on this'),
              ),
              _buildActionButton(
                icon: card.listening ? Icons.stop_rounded : Icons.volume_up_outlined,
                label: card.listening ? 'Stop' : 'Listen',
                bgColor: const Color(0xFFE7E3F6),
                textColor: const Color(0xFF5D4E9A),
                onTap: () {
                  setState(() => card.listening = !card.listening);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? const Color(0xFF12302E) : const Color(0xFF7E9592),
            fontFamily: 'Figtree',
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: textColor),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: textColor,
                fontFamily: 'Figtree',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionPill(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => _handleSendMessage(title),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFD6E9EC),
                Color(0xFFE0EEEF),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF12302E),
                    fontFamily: 'Figtree',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: Color(0xFF12302E),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComposerBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFE6ECEA)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Plus Attach Button
          GestureDetector(
            onTap: _showAttachmentSheet,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEEF1EF),
              ),
              child: const Center(
                child: Icon(
                  Icons.add_rounded,
                  size: 20,
                  color: Color(0xFF12302E),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Input Text Field
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: (_) => _handleSendMessage(),
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF12302E),
                fontFamily: 'Figtree',
              ),
              decoration: InputDecoration(
                hintText: _isRecording ? 'Listening…' : 'Type your answer…',
                hintStyle: TextStyle(
                  color: _isRecording ? const Color(0xFF1E6B63) : const Color(0xFF9DB0AD),
                  fontSize: 14.5,
                  fontFamily: 'Figtree',
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          // Mic Button
          GestureDetector(
            onTap: () {
              setState(() => _isRecording = !_isRecording);
              if (_isRecording) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Listening to voice response...'), duration: Duration(seconds: 1)),
                );
              }
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isRecording ? const Color(0xFFFBE3D7) : Colors.transparent,
              ),
              child: Center(
                child: Icon(
                  Icons.mic_none_rounded,
                  size: 20,
                  color: _isRecording ? const Color(0xFFB0573F) : const Color(0xFF4B6462),
                ),
              ),
            ),
          ),

          const SizedBox(width: 4),

          // Send Button
          GestureDetector(
            onTap: () => _handleSendMessage(),
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF163E3A),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 19,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE2E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 18),
                ListTile(
                  leading: const Icon(Icons.image_outlined, color: Color(0xFF1E6B63)),
                  title: const Text('Attach Clinical Image / Diagram'),
                  onTap: () => Navigator.pop(ctx),
                ),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf_outlined, color: Color(0xFF1E6B63)),
                  title: const Text('Attach ECG / Patient PDF Report'),
                  onTap: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE2E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 18),
                ListTile(
                  leading: const Icon(Icons.refresh_rounded, color: Color(0xFF1E6B63)),
                  title: const Text('Restart Case'),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _initializeChat();
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.tune_rounded, color: Color(0xFF1E6B63)),
                  title: const Text('Switch Teacher or Mode'),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.pushNamed(
                      context,
                      '/choose-mode',
                      arguments: {'scenario': _scenario},
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share_outlined, color: Color(0xFF1E6B63)),
                  title: const Text('Export Clinical Summary'),
                  onTap: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChatMessage {
  final bool isUser;
  final String? text;
  final _RichCardData? richCard;

  _ChatMessage({
    required this.isUser,
    this.text,
    this.richCard,
  });
}

class _RichCardData {
  final String tag;
  final String leadText;
  final String boldKeyword;
  final String trailingLeadText;
  final String kpTitle;
  final String kpLeftBig;
  final String kpLeftSmall;
  final String kpSign;
  final String kpRightBig;
  final String kpRightSmall;
  final String analogyText;
  final String? detailedNote;
  final String questionText;
  bool saved;
  bool listening;
  bool isDetailed;

  _RichCardData({
    required this.tag,
    required this.leadText,
    required this.boldKeyword,
    required this.trailingLeadText,
    required this.kpTitle,
    required this.kpLeftBig,
    required this.kpLeftSmall,
    required this.kpSign,
    required this.kpRightBig,
    required this.kpRightSmall,
    required this.analogyText,
    this.detailedNote,
    required this.questionText,
    this.saved = false,
    this.listening = false,
    this.isDetailed = false,
  });
}
