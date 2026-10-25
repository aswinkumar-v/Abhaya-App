import 'package:flutter/material.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/fuss_avatar.dart';

class WellbeingScreen extends StatefulWidget {
  const WellbeingScreen({super.key});

  @override
  State<WellbeingScreen> createState() => _WellbeingScreenState();
}

class _WellbeingScreenState extends State<WellbeingScreen> {
  String _selectedMood = 'Happy';
  bool _requestedSupport = false;
  final TextEditingController _journalController = TextEditingController();

  final List<Map<String, dynamic>> _moods = [
    {
      'name': 'Low',
      'mood': FussMood.sad,
      'msg': 'Be gentle with yourself. One small task is enough today.',
    },
    {
      'name': 'Tired',
      'mood': FussMood.tired,
      'msg': 'Rest is productive too. Take a quick 5 minute breather.',
    },
    {
      'name': 'Happy',
      'mood': FussMood.happy,
      'msg': 'Lovely to hear. Ride the energy, your plan has a quick Immunology quiz today.',
    },
    {
      'name': 'Okay',
      'mood': FussMood.okay,
      'msg': 'Steady is fine. Start with the shortest task on your list.',
    },
    {
      'name': 'Stressed',
      'mood': FussMood.stressed,
      'msg': 'Let’s take a 1 minute breather together before continuing.',
    },
  ];

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserService.instance,
      builder: (context, _) {
        final user = UserService.instance;
        final curMoodObj = _moods.firstWhere((m) => m['name'] == _selectedMood);

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Bar: Private to you pill
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE6ECEA)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.ink),
                          SizedBox(width: 6),
                          Text(
                            'Private to you',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink,
                              fontFamily: 'Figtree',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Headline: "Hello, {name} / how's your heart today?"
                  Text(
                    'Hello, ${user.greetingName}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                      letterSpacing: -0.5,
                      fontFamily: 'Figtree',
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "how's your heart today?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF7E908B),
                      letterSpacing: -0.3,
                      fontFamily: 'Figtree',
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Stat Counter: Check-ins this week
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        user.checkInsThisWeek.toString().padLeft(2, '0'),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                          letterSpacing: -0.5,
                          fontFamily: 'Figtree',
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '07',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFB0BCB8),
                          letterSpacing: -0.5,
                          fontFamily: 'Figtree',
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Check-ins\nthis week',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF7E908B),
                          height: 1.25,
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

              // Card 1: Mood Tracker Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
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
                  children: [
                    // Row of 5 moods
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _moods.map((m) {
                        final name = m['name'] as String;
                        final mood = m['mood'] as FussMood;
                        final isSel = name == _selectedMood;

                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedMood = name);
                            user.recordMoodCheckIn(name);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FussAvatar(
                                size: isSel ? 44 : 38,
                                mood: mood,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                  color: isSel ? AppColors.ink : AppColors.ink2,
                                  fontFamily: 'Figtree',
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Selected Mood Response Bubble
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FussAvatar(size: 64, mood: curMoodObj['mood'] as FussMood),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F4FD),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fuss',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF6A5FC0),
                                    fontFamily: 'Figtree',
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  curMoodObj['msg'] as String,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    color: AppColors.ink,
                                    height: 1.4,
                                    fontFamily: 'Figtree',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Card 2: Talk to Fuss Card
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/listener-chat'),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFE7EDEB)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Talk to Fuss',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ink,
                                      fontFamily: 'Figtree',
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Your AI listener. Private and kind.',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: AppColors.ink2,
                                      fontFamily: 'Figtree',
                                    ),
                                  ),
                                  const SizedBox(height: 14),

                                  // Split stats: Available & Last chat
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Available',
                                            style: TextStyle(fontSize: 11, color: AppColors.ink3, fontFamily: 'Figtree'),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            'Any time',
                                            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.ink, fontFamily: 'Figtree'),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 28,
                                        width: 1,
                                        color: const Color(0xFFE6ECEA),
                                        margin: const EdgeInsets.symmetric(horizontal: 14),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Last chat',
                                            style: TextStyle(fontSize: 11, color: AppColors.ink3, fontFamily: 'Figtree'),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            '10 min · Mon',
                                            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.ink, fontFamily: 'Figtree'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Fuss with sound waves
                            const FussAvatar(size: 76, mood: FussMood.calm, showSoundWaves: true),
                          ],
                        ),
                      ),

                      // Bottom strip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        color: const Color(0xFFFDEDE4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Talk it out',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                                fontFamily: 'Figtree',
                              ),
                            ),
                            Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.ink),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Section 3: Take a moment
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Take a moment',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                      letterSpacing: -0.3,
                      fontFamily: 'Figtree',
                    ),
                  ),
                  Text(
                    'Small resets',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ink3,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 2x2 Grid of Resets
              Row(
                children: [
                  Expanded(
                    child: _buildResetCard(
                      title: 'Breathe',
                      subtitle: '4-7-8 technique',
                      value: '${user.breathingMinutesThisWeek}min',
                      valueColor: AppColors.teal,
                      gradient: const [Color(0xFFE4F4EF), Color(0xFFC8E8DE)],
                      icon: const Icon(Icons.air_rounded, size: 20, color: AppColors.teal),
                      onTap: () => Navigator.pushNamed(context, '/breathing'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildResetCard(
                      title: 'Journal',
                      subtitle: 'Entries this week',
                      value: '${user.journalEntriesCount}',
                      valueColor: const Color(0xFF2F6F8F),
                      gradient: const [Color(0xFFE6F1F6), Color(0xFFCBE1EC)],
                      icon: const Icon(Icons.edit_outlined, size: 19, color: Color(0xFF2F6F8F)),
                      onTap: () => Navigator.pushNamed(context, '/journal'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildResetCard(
                      title: 'Daily motivation',
                      subtitle: 'Thoughts for today',
                      value: '1/4',
                      valueColor: const Color(0xFFB58428),
                      gradient: const [Color(0xFFFFF3D6), Color(0xFFFDE5A8)],
                      icon: const Icon(Icons.wb_sunny_outlined, size: 20, color: Color(0xFFB58428)),
                      onTap: () => Navigator.pushNamed(context, '/motivation'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildResetCard(
                      title: 'Calm audio',
                      subtitle: 'Rain · piano',
                      value: '10min',
                      valueColor: const Color(0xFF6150B5),
                      gradient: const [Color(0xFFEFEDFB), Color(0xFFDAD4F4)],
                      icon: const Icon(Icons.music_note_rounded, size: 20, color: Color(0xFF6150B5)),
                      onTap: () => Navigator.pushNamed(context, '/calm-audio'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Card 4: Today's entry
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F2EC),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            "Today's entry",
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                              fontFamily: 'Figtree',
                            ),
                          ),
                        ),
                        const Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.ink3,
                            fontFamily: 'Figtree',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    user.journalEntries.isNotEmpty
                        ? Text(
                            '“${user.journalEntries.first.text}”',
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.ink,
                              height: 1.45,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Figtree',
                            ),
                          )
                        : TextField(
                            controller: _journalController,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              hintText: '“In stillness, clarity emerges.” What\'s on your mind?',
                              hintStyle: TextStyle(fontSize: 15, color: Color(0xFF7E908B)),
                              border: InputBorder.none,
                            ),
                          ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Only you can read this',
                          style: TextStyle(fontSize: 12, color: AppColors.ink3, fontFamily: 'Figtree'),
                        ),
                        GestureDetector(
                          onTap: () {
                            final text = _journalController.text.trim();
                            if (text.isNotEmpty) {
                              user.addJournalEntry(tag: 'Mindfulness', text: text);
                              _journalController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Journal entry saved privately.')),
                              );
                            } else {
                              Navigator.pushNamed(context, '/journal');
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                            decoration: BoxDecoration(
                              color: const Color(0xFF123832),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              user.journalEntries.isNotEmpty ? 'New entry' : 'Save entry',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Figtree',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Card 5: Check-in streak
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Check-in streak',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                            fontFamily: 'Figtree',
                          ),
                        ),
                        Text(
                          '${user.checkInsThisWeek} ${user.checkInsThisWeek == 1 ? "day" : "days"}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E6B63),
                            fontFamily: 'Figtree',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 7 days row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStreakDay('Mon', isDone: user.checkInsThisWeek >= 1),
                        _buildStreakDay('Tue', isDone: user.checkInsThisWeek >= 2),
                        _buildStreakDay('Wed', isDone: user.checkInsThisWeek >= 3),
                        _buildStreakDay('Thu', isDone: user.checkInsThisWeek >= 4),
                        _buildStreakDay('Fri', isDone: user.checkInsThisWeek >= 5),
                        _buildStreakDay('Sat', isDone: user.checkInsThisWeek >= 6),
                        _buildStreakDay('Sun', isDone: user.checkInsThisWeek >= 7),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Card 6: Need help from a real person?
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE1EFEC), Color(0xFFEAF2EF)],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.favorite_outline_rounded,
                            size: 18,
                            color: Color(0xFF1E6B63),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Need help from a real person?',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                  fontFamily: 'Figtree',
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'A teacher or campus counsellor will reach out to you privately.',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: AppColors.ink2,
                                  height: 1.35,
                                  fontFamily: 'Figtree',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () {
                        setState(() => _requestedSupport = true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Support request sent privately.')),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _requestedSupport ? const Color(0xFF2E6E64) : const Color(0xFF123832),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _requestedSupport ? '✓ Request sent' : 'Request support',
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Figtree',
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
      ),
    );
      },
    );
  }

  Widget _buildResetCard({
    required String title,
    required String subtitle,
    required String value,
    required Color valueColor,
    required List<Color> gradient,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 146,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative background circle in bottom right
            Positioned(
              right: -15,
              bottom: -20,
              child: Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
            ),

            // Main layout: Top row, middle text, bottom value
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Icon on left, arrow in circle on right
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      child: Center(child: icon),
                    ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 15,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Title & Subtitle
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    letterSpacing: -0.2,
                    fontFamily: 'Figtree',
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.ink2,
                    fontFamily: 'Figtree',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const Spacer(),

                // Value at bottom-left
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: valueColor,
                    letterSpacing: -0.3,
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

  Widget _buildStreakDay(String day, {required bool isDone, bool isToday = false}) {
    return Column(
      children: [
        SizedBox(
          width: 38,
          height: 38,
          child: !isDone
              ? CustomPaint(
                  size: const Size(38, 38),
                  painter: _DashedCirclePainter(color: const Color(0xFFC3CFCC)),
                )
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isToday
                        ? const Color(0xFF152A26)
                        : const Color(0xFF3DA68E),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
        ),
        const SizedBox(height: 6),
        Text(
          day,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
            color: isToday ? AppColors.ink : AppColors.ink2,
            fontFamily: 'Figtree',
          ),
        ),
      ],
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int dashCount;

  _DashedCirclePainter({
    required this.color,
    this.strokeWidth = 1.3,
    this.dashCount = 14,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final radius = (size.width - strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    const double totalAngle = 2 * 3.141592653589793;
    final double stepAngle = totalAngle / dashCount;
    final double dashAngle = stepAngle * 0.52;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * stepAngle;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}
