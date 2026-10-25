import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';

class ListenerChatScreen extends StatefulWidget {
  const ListenerChatScreen({super.key});

  @override
  State<ListenerChatScreen> createState() => _ListenerChatScreenState();
}

class _ListenerChatScreenState extends State<ListenerChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  late final List<Map<String, dynamic>> _messages;

  @override
  void initState() {
    super.initState();
    final name = UserService.instance.greetingName;
    _messages = [
      {
        'isUser': false,
        'text':
            "Hi $name, it's Fuss. I'm here to listen, no judgement. What's on your mind?",
      },
    ];
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage([String? textToSend]) {
    final text = textToSend ?? _textController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.lightImpact();
    setState(() {
      _messages.add({'isUser': true, 'text': text});
      _textController.clear();
      _isTyping = true;
    });
    _scrollToBottom();

    // Empathetic, supportive contextual response
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      final reply = _generateEmpatheticReply(text);
      setState(() {
        _isTyping = false;
        _messages.add({'isUser': false, 'text': reply});
      });
      _scrollToBottom();
    });
  }

  String _generateEmpatheticReply(String input) {
    final lower = input.toLowerCase().trim();
    if (lower.startsWith('hi') || lower.startsWith('hello') || lower == 'hey') {
      return "Hello! I'm right here with you. Take your time—tell me whatever is on your mind today.";
    } else if (lower.contains('thank') || lower.contains('thanks')) {
      return "You're always welcome. I'm here 24/7 whenever you need a calm ear. Take good care of yourself today!";
    } else if (lower.contains('exam') ||
        lower.contains('osce') ||
        lower.contains('freeze') ||
        lower.contains('practical') ||
        lower.contains('viva') ||
        lower.contains('test')) {
      return "That fear makes sense. Practicals feel exposed, and you care about doing well. Is it the skill itself or being watched that worries you most?";
    } else if (lower.contains('tired') ||
        lower.contains('exhaust') ||
        lower.contains('sleep') ||
        lower.contains('shift') ||
        lower.contains('burnout') ||
        lower.contains('drained')) {
      return "Long nursing clinicals and continuous learning take a deep physical toll. It's completely okay to feel drained. Have you been able to take a quiet rest or drink some water today?";
    } else if (lower.contains('anxious') ||
        lower.contains('stress') ||
        lower.contains('scared') ||
        lower.contains('nervous') ||
        lower.contains('panic') ||
        lower.contains('worry')) {
      return "Take a slow breath right now. Inhale gently... and let it out. Whatever feels overwhelming, we can break it down together. You don't have to carry it all at once.";
    } else if (lower.contains('mistake') ||
        lower.contains('fail') ||
        lower.contains('wrong') ||
        lower.contains('afraid')) {
      return "Carrying patient care on your shoulders can feel so heavy. Second-guessing yourself usually means you care deeply. Let's take a slow breath. You are learning and you did your best.";
    } else if (lower.contains('patient') ||
        lower.contains('doctor') ||
        lower.contains('hospital') ||
        lower.contains('ward') ||
        lower.contains('cry')) {
      return "Clinical ward environments can be emotionally intense. Feeling affected shows your empathy as a future nurse. Take this quiet moment just for you.";
    } else if (lower.contains('study') ||
        lower.contains('book') ||
        lower.contains('memoriz') ||
        lower.contains('drug') ||
        lower.contains('pharmacology')) {
      return "Nursing coursework has so much information to absorb. When it feels like too much, pausing for 5 minutes often resets your retention. How can I help you unpack it?";
    }
    return "Thank you for telling me. Let’s take it one piece at a time. What would feel most comforting or helpful for you right now?";
  }

  void _showFacultyModal() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 34),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4.5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6DFDC),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Faculty & Wellbeing Support',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
                fontFamily: 'Figtree',
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Confidential support is always available whenever you need a human listener.',
              style: TextStyle(
                fontSize: 13.5,
                color: AppColors.ink3,
                fontFamily: 'Figtree',
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            _buildContactTile(
              icon: Icons.person_outline_rounded,
              title: 'Nursing Academic Advisor',
              subtitle: 'Dr. Sarah Mathews · Room 304, Academic Block',
              actionLabel: 'Send email',
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening email draft to academic advisor...')),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildContactTile(
              icon: Icons.favorite_outline_rounded,
              title: 'Student Wellbeing Counselor',
              subtitle: '24/7 Campus Crisis & Emotional Helpline',
              actionLabel: 'Call helpline',
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling Student Wellbeing Helpline...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionLabel,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5EDE9)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2EBE6)),
            ),
            child: Icon(icon, color: const Color(0xFF163430), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    fontFamily: 'Figtree',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.ink3,
                    fontFamily: 'Figtree',
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              foregroundColor: const Color(0xFF1E6B63),
              textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9), // Soft lilac-mint prototype canvas
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: SafeArea(
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: Row(
              children: [
                // Circular Back Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE4ECE8)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF12302E).withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      color: Color(0xFF1E2F2C),
                      size: 26,
                    ),
                  ),
                ),

                // Center Title & Online 24/7 Subtitle
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Talk to Fuss',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF172926),
                          letterSpacing: -0.2,
                          fontFamily: 'Figtree',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.5,
                            height: 6.5,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF3FB8A0), // #3FB8A0
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Private to you · 24/7',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B7E7A),
                              fontFamily: 'Figtree',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Symmetrical placeholder
                const SizedBox(width: 42),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat & Suggestions List
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
                children: [
                  // ── Hero Mascot & Title Section ───────────────────────
                  const SizedBox(height: 4),
                  const Center(child: _ListenerHeroFuss()),
                  const SizedBox(height: 12),
                  const Text(
                    "I'm here to listen",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF152A27),
                      letterSpacing: -0.4,
                      fontFamily: 'Figtree',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Private, kind, judgement-free.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6E807D),
                      fontFamily: 'Figtree',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Chat Messages ────────────────────────────────────
                  ..._messages.map((m) {
                    final isUser = m['isUser'] as bool;
                    return _buildChatBubble(
                      text: m['text'] as String,
                      isUser: isUser,
                    );
                  }),

                  // Typing indicator when Fuss is responding
                  if (_isTyping) _buildTypingIndicator(),

                  const SizedBox(height: 12),

                  // ── "Might help now" Action Cards ────────────────────
                  const Text(
                    'Might help now',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6C7F7B),
                      fontFamily: 'Figtree',
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 1. "2-min breathing" card
                  _buildHelpCard(
                    title: '2-min breathing',
                    backgroundGradient: const LinearGradient(
                      colors: [Color(0xFFE2F3EE), Color(0xFFD8EFE8)],
                    ),
                    textColor: const Color(0xFF143B35),
                    onTap: () => Navigator.pushNamed(context, '/breathing'),
                  ),
                  const SizedBox(height: 10),

                  // 2. "Reach a faculty member" card
                  _buildHelpCard(
                    title: 'Reach a faculty member',
                    backgroundGradient: const LinearGradient(
                      colors: [Color(0xFFE4E0F5), Color(0xFFECE9F8)],
                    ),
                    textColor: const Color(0xFF282548),
                    onTap: _showFacultyModal,
                  ),
                ],
              ),
            ),

            // ── Bottom Message Composer ─────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(18, 6, 18, 14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFE1E8E5), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF12302E).withValues(alpha: 0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        style: const TextStyle(
                          fontSize: 14.5,
                          color: AppColors.ink,
                          fontFamily: 'Figtree',
                        ),
                        decoration: const InputDecoration(
                          hintText: "Share what's on your mind…",
                          hintStyle: TextStyle(
                            fontSize: 14.5,
                            color: Color(0xFF869793),
                            fontFamily: 'Figtree',
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _sendMessage(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: Color(0xFF183431), // Deep dark teal from prototype
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
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

  Widget _buildChatBubble({required String text, required bool isUser}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.84,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF183431) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isUser ? 22 : 8),
            topRight: Radius.circular(isUser ? 8 : 22),
            bottomLeft: const Radius.circular(22),
            bottomRight: const Radius.circular(22),
          ),
          boxShadow: [
            BoxShadow(
              color: isUser
                  ? const Color(0xFF183431).withValues(alpha: 0.16)
                  : const Color(0xFF12302E).withValues(alpha: 0.06),
              blurRadius: isUser ? 12 : 16,
              offset: const Offset(0, 4),
            ),
          ],
          border: isUser ? null : Border.all(color: const Color(0xFFE8EFEA)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.5,
            height: 1.5,
            fontWeight: FontWeight.w400,
            color: isUser ? Colors.white : const Color(0xFF1D2B29),
            fontFamily: 'Figtree',
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(22),
            bottomLeft: Radius.circular(22),
            bottomRight: Radius.circular(22),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF12302E).withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFE8EFEA)),
        ),
        child: const _BouncingDotsIndicator(),
      ),
    );
  }

  Widget _buildHelpCard({
    required String title,
    required Gradient backgroundGradient,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          gradient: backgroundGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF12302E).withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontFamily: 'Figtree',
                ),
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Three soft pulsing dots for AI typing indication
class _BouncingDotsIndicator extends StatefulWidget {
  const _BouncingDotsIndicator();

  @override
  State<_BouncingDotsIndicator> createState() => _BouncingDotsIndicatorState();
}

class _BouncingDotsIndicatorState extends State<_BouncingDotsIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final val = (_ctrl.value - delay).clamp(0.0, 1.0);
            final bounce = math.sin(val * math.pi);
            return Container(
              margin: EdgeInsets.only(right: index == 2 ? 0 : 5),
              width: 7,
              height: 7,
              transform: Matrix4.translationValues(0, -bounce * 4, 0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF5CC2B2).withValues(alpha: 0.4 + bounce * 0.6),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Floating Hero Fuss listening companion (.lorb.glow)
class _ListenerHeroFuss extends StatefulWidget {
  const _ListenerHeroFuss();

  @override
  State<_ListenerHeroFuss> createState() => _ListenerHeroFussState();
}

class _ListenerHeroFussState extends State<_ListenerHeroFuss>
    with TickerProviderStateMixin {
  // 1. Halo glow: 5s ease-in-out infinite (scale: 1.0 -> 1.06, opacity: 0.85 -> 1.0)
  late final AnimationController _glowCtrl;
  late final Animation<double> _glowScale;
  late final Animation<double> _glowOpacity;

  // 2. Body breathing: 4.2s ease-in-out infinite
  late final AnimationController _breatheCtrl;
  late final Animation<double> _bodyScaleX;
  late final Animation<double> _bodyScaleY;
  late final Animation<double> _shadowScale;

  // 3. Ear glow: 3.2s ease-in-out infinite
  late final AnimationController _earCtrl;
  late final Animation<double> _earOpacity;

  // 4. Soundwave pulse: 1.4s ease-in-out infinite
  late final AnimationController _waveCtrl;
  late final Animation<double> _waveScaleY;

  @override
  void initState() {
    super.initState();

    // 1. Halo Glow
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    _glowScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );
    _glowOpacity = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );

    // 2. Breathing & Shadow
    _breatheCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2100),
    )..repeat(reverse: true);
    _bodyScaleX = Tween<double>(begin: 1.0, end: 1.025).animate(
      CurvedAnimation(parent: _breatheCtrl, curve: Curves.easeInOut),
    );
    _bodyScaleY = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _breatheCtrl, curve: Curves.easeInOut),
    );
    _shadowScale = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _breatheCtrl, curve: Curves.easeInOut),
    );

    // 3. Glowing Ear
    _earCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _earOpacity = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _earCtrl, curve: Curves.easeInOut),
    );

    // 4. Soundwave
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _waveScaleY = Tween<double>(begin: 0.7, end: 1.1).animate(
      CurvedAnimation(parent: _waveCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    _breatheCtrl.dispose();
    _earCtrl.dispose();
    _waveCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.of(context).disableAnimations;

    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // ── Blurred Radial Gradient Halo (.lorb::before) ───────────
          AnimatedBuilder(
            animation: _glowCtrl,
            builder: (context, _) {
              final sc = reduced ? 1.0 : _glowScale.value;
              final op = reduced ? 0.85 : _glowOpacity.value;

              return Transform.scale(
                scale: sc,
                child: Opacity(
                  opacity: op.clamp(0.0, 1.0),
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        center: Alignment(-0.4, -0.4), // circle at 30% 30%
                        radius: 0.8,
                        colors: [
                          Color(0xFFF3B07F), // 0%
                          Color(0xFFF5C4A4), // 30%
                          Color(0xFFC9C8F2), // 62%
                          Color(0xFF9DB5F2), // 100%
                        ],
                        stops: [0.0, 0.30, 0.62, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFC9C8F2).withValues(alpha: 0.45),
                          blurRadius: 20,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // ── Fuss Listening Mascot (.fuss.md.calm.listen) ────────────
          SizedBox(
            width: 100,
            height: 100,
            child: AnimatedBuilder(
              animation: Listenable.merge(
                reduced ? [] : [_breatheCtrl, _earCtrl, _waveCtrl],
              ),
              builder: (context, _) {
                final sx = reduced ? 1.0 : _bodyScaleX.value;
                final sy = reduced ? 1.0 : _bodyScaleY.value;
                final shSc = reduced ? 1.0 : _shadowScale.value;
                final earOp = reduced ? 0.95 : _earOpacity.value;
                final waveSc = reduced ? 1.0 : _waveScaleY.value;

                return CustomPaint(
                  size: const Size(100, 100),
                  painter: _FussListeningPainter(
                    bodyScaleX: sx,
                    bodyScaleY: sy,
                    shadowScale: shSc,
                    earOpacity: earOp,
                    waveScaleY: waveSc,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the Fuss mascot with breathing body, glowing ear, and listening wave
class _FussListeningPainter extends CustomPainter {
  final double bodyScaleX;
  final double bodyScaleY;
  final double shadowScale;
  final double earOpacity;
  final double waveScaleY;

  const _FussListeningPainter({
    required this.bodyScaleX,
    required this.bodyScaleY,
    required this.shadowScale,
    required this.earOpacity,
    required this.waveScaleY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 200.0;

    // ── 1. Shadow ──────────────────────────────────────────────────
    canvas.save();
    canvas.translate(104 * s, 188 * s);
    canvas.scale(shadowScale);
    canvas.translate(-104 * s, -188 * s);

    final shadowPaint = Paint()
      ..color = const Color(0xFF9C92D6).withValues(alpha: 0.28);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(104 * s, 188 * s),
        width: 132 * s,
        height: 14 * s,
      ),
      shadowPaint,
    );
    canvas.restore();

    // ── 2. Body ────────────────────────────────────────────────────
    canvas.save();
    canvas.translate(104 * s, 188 * s);
    canvas.scale(bodyScaleX, bodyScaleY);
    canvas.translate(-104 * s, -188 * s);

    final fzB = RadialGradient(
      center: const Alignment(-0.2, -0.5),
      radius: 0.85,
      colors: const [
        Color(0xFFFFFFFF),
        Color(0xFFF1EEFA),
        Color(0xFFD9D3F1),
        Color(0xFFBDB3E6),
      ],
      stops: const [0.0, 0.38, 0.72, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final fzF = RadialGradient(
      center: const Alignment(-0.1, -0.4),
      radius: 0.75,
      colors: const [
        Color(0xFFFFFFFF),
        Color(0xFFE6E1F6),
        Color(0xFFC3B9EA),
      ],
      stops: const [0.0, 0.55, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final fzE = RadialGradient(
      colors: [
        const Color(0xFFFFAE9C).withValues(alpha: (0.95 * earOpacity).clamp(0.0, 1.0)),
        const Color(0xFFFFC2B4).withValues(alpha: (0.45 * earOpacity).clamp(0.0, 1.0)),
        const Color(0xFFFFC2B4).withValues(alpha: 0.0),
      ],
      stops: const [0.0, 0.60, 1.0],
    ).createShader(Rect.fromCircle(center: Offset(56 * s, 92 * s), radius: 34 * s));

    final fzT = RadialGradient(
      colors: [
        const Color(0xFF8FDDEB).withValues(alpha: 0.55),
        const Color(0xFF8FDDEB).withValues(alpha: 0.0),
      ],
    ).createShader(Rect.fromCircle(center: Offset(60 * s, 122 * s), radius: 50 * s));

    final fzC = RadialGradient(
      colors: [
        const Color(0xFFFF9EA8).withValues(alpha: 0.55),
        const Color(0xFFFF9EA8).withValues(alpha: 0.0),
      ],
    ).createShader(Rect.fromCircle(center: Offset(118 * s, 116 * s), radius: 14 * s));

    final bodyPaintB = Paint()..shader = fzB;
    final bodyPaintF = Paint()..shader = fzF;
    final cyanPaint = Paint()..shader = fzT;
    final earPaint = Paint()..shader = fzE;
    final cheekPaint = Paint()..shader = fzC;

    // Body segments
    canvas.drawOval(
      Rect.fromCenter(center: Offset(150 * s, 160 * s), width: 54 * s, height: 46 * s),
      bodyPaintF,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(104 * s, 142 * s), width: 112 * s, height: 84 * s),
      bodyPaintB,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(104 * s, 86 * s), width: 136 * s, height: 128 * s),
      bodyPaintB,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(60 * s, 122 * s), width: 88 * s, height: 100 * s),
      cyanPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(58 * s, 150 * s), width: 40 * s, height: 48 * s),
      bodyPaintF,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(96 * s, 166 * s), width: 58 * s, height: 46 * s),
      bodyPaintF,
    );

    // Glowing warm ear
    canvas.drawCircle(Offset(56 * s, 92 * s), 34 * s, earPaint);

    // Cheeks
    canvas.drawCircle(Offset(118 * s, 116 * s), 12 * s, cheekPaint);
    canvas.drawCircle(Offset(162 * s, 113 * s), 10 * s, cheekPaint);

    // Calm Face Expression
    final faceStroke = Paint()
      ..color = const Color(0xFF2B2547)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final eye1 = Path()
      ..moveTo(110 * s, 100 * s)
      ..quadraticBezierTo(118 * s, 107 * s, 126 * s, 100 * s);
    final eye2 = Path()
      ..moveTo(150 * s, 98 * s)
      ..quadraticBezierTo(157 * s, 104 * s, 163 * s, 98 * s);
    final mouth = Path()
      ..moveTo(133 * s, 115 * s)
      ..quadraticBezierTo(137 * s, 118 * s, 141 * s, 115 * s);

    canvas.drawPath(eye1, faceStroke);
    canvas.drawPath(eye2, faceStroke);
    canvas.drawPath(mouth, faceStroke);

    canvas.restore(); // end of body

    // ── 3. Soundwave Lines ─────────────────────────────────────────
    canvas.save();
    canvas.translate(39 * s, 94 * s);
    canvas.scale(1.0, waveScaleY);
    canvas.translate(-39 * s, -94 * s);

    final shadowWavePaint = Paint()
      ..color = const Color(0xFFFFBEAA).withValues(alpha: 0.90)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.6 * s
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);

    final wavePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6 * s
      ..strokeCap = StrokeCap.round;

    const bars = [
      [18.0, 92.0, 4.0],
      [24.0, 89.0, 10.0],
      [30.0, 84.0, 20.0],
      [36.0, 78.0, 32.0],
      [42.0, 72.0, 44.0],
      [48.0, 80.0, 28.0],
      [54.0, 86.0, 16.0],
      [60.0, 90.0, 8.0],
    ];

    for (final b in bars) {
      final x = b[0] * s;
      final y1 = b[1] * s;
      final y2 = (b[1] + b[2]) * s;
      canvas.drawLine(Offset(x, y1), Offset(x, y2), shadowWavePaint);
      canvas.drawLine(Offset(x, y1), Offset(x, y2), wavePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FussListeningPainter oldDelegate) =>
      oldDelegate.bodyScaleX != bodyScaleX ||
      oldDelegate.bodyScaleY != bodyScaleY ||
      oldDelegate.shadowScale != shadowScale ||
      oldDelegate.earOpacity != earOpacity ||
      oldDelegate.waveScaleY != waveScaleY;
}
