import 'package:flutter/material.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/feature_icons.dart';
import '../../core/widgets/celestial_tutor_orb.dart';

class ChatCentreScreen extends StatelessWidget {
  const ChatCentreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserService.instance,
      builder: (context, _) {
        final user = UserService.instance;

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // New Chat circle button
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/choose-scenario'),
                          child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE6ECEA)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add_rounded, size: 22, color: AppColors.ink),
                      ),
                    ),

                    // Title & Live status
                    Column(
                      children: [
                        const Text(
                          'Abhaya Tutor',
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                            letterSpacing: -0.3,
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
                                color: Color(0xFF3FB39E),
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              'Online · 24/7',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.ink3,
                                fontFamily: 'Figtree',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Search circle button
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE6ECEA)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.search_rounded, size: 20, color: AppColors.ink),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // Glowing Celestial Constellation Orb
              const Center(
                child: CelestialTutorOrb(size: 200),
              ),

              const SizedBox(height: 18),

              // Headline: "Hi {name}, let's learn"
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Hi ${UserService.instance.greetingName}, ',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                      letterSpacing: -0.4,
                      fontFamily: 'Figtree',
                    ),
                    children: const [
                      TextSpan(
                        text: "let's learn",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2A8A7E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // Subtitle
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 290),
                  child: const Text(
                    'I explain things your way: with stories, real-life examples or step by step.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: AppColors.ink2,
                      height: 1.4,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Action button: + Start a new chat
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/choose-scenario'),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E6B63),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E6B63).withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_rounded, size: 20, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Start a new chat',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'Figtree',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 3-step indicator: 1 Pick what to do · 2 Pick a teacher · 3 Start learning
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStep('1', 'Pick what to do'),
                  const SizedBox(width: 14),
                  _buildStep('2', 'Pick a teacher'),
                  const SizedBox(width: 14),
                  _buildStep('3', 'Start learning'),
                ],
              ),

              const SizedBox(height: 26),

              // Section 1: Quick starts
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick starts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: -0.3,
                        fontFamily: 'Figtree',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 2x2 Grid of Quick starts
                    Row(
                      children: [
                        Expanded(
                          child: _buildTile(
                            context: context,
                            title: 'Explain a topic',
                            subtitle: 'Any concept, simply',
                            gradient: const [Color(0xFFE4F4EF), Color(0xFFC8E8DE)],
                            icon: const Icon(Icons.menu_book_outlined, size: 20, color: AppColors.teal),
                            onTap: () => Navigator.pushNamed(context, '/choose-mode'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTile(
                            context: context,
                            title: 'Practise a case',
                            subtitle: 'Think like a nurse',
                            gradient: const [Color(0xFFFDEDE4), Color(0xFFF6D3C2)],
                            icon: const ClinicalCasesIcon(size: 20, color: Color(0xFFB5603F)),
                            onTap: () => Navigator.pushNamed(context, '/choose-mode'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTile(
                            context: context,
                            title: 'Quiz me on drugs',
                            subtitle: 'Quick recall',
                            gradient: const [Color(0xFFE6F1F6), Color(0xFFCBE1EC)],
                            icon: const Icon(Icons.help_outline_rounded, size: 20, color: Color(0xFF2F6F8F)),
                            onTap: () => Navigator.pushNamed(context, '/choose-mode'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTile(
                            context: context,
                            title: 'Viva prep',
                            subtitle: 'Practise answers',
                            gradient: const [Color(0xFFFFF3D6), Color(0xFFFDE5A8)],
                            icon: const Icon(Icons.star_outline_rounded, size: 20, color: Color(0xFFB58428)),
                            onTap: () => Navigator.pushNamed(context, '/choose-mode'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Section 2: Saved conversations
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Saved conversations',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                            letterSpacing: -0.3,
                            fontFamily: 'Figtree',
                          ),
                        ),
                        Text(
                          user.savedChats.isEmpty ? '0 chats' : '${user.savedChats.length} chats',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.ink3,
                            fontFamily: 'Figtree',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (user.savedChats.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE6ECEA)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEAF5F1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF1E6B63), size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'No saved conversations yet',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ink,
                                      fontFamily: 'Figtree',
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Select a clinical tutor or scenario above to start learning.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF7E908B),
                                      fontFamily: 'Figtree',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE6ECEA)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: user.savedChats.asMap().entries.map((entry) {
                            final i = entry.key;
                            final chat = entry.value;
                            final isLast = i == user.savedChats.length - 1;
                            return Column(
                              children: [
                                _buildConversationItem(
                                  context: context,
                                  initials: chat.character.split(' ').map((s) => s.isNotEmpty ? s[0] : '').take(2).join(),
                                  initialsBg: const Color(0xFFD5EFE6),
                                  initialsColor: const Color(0xFF1E6B63),
                                  title: chat.topic,
                                  subtitle: '${chat.character} · ${chat.mode}',
                                  time: chat.timeAgo,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    '/chat',
                                    arguments: {'character': chat.character, 'topic': chat.topic},
                                  ),
                                ),
                                if (!isLast)
                                  const Divider(height: 1, color: Color(0xFFEFF3F1), indent: 64),
                              ],
                            );
                          }).toList(),
                        ),
                      ),

                    const SizedBox(height: 12),

                    // Discussion forum card with dashed border
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFC3D3CF),
                          width: 1.5,
                          strokeAlign: BorderSide.strokeAlignCenter,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFFF1D6),
                            ),
                            child: const Icon(
                              Icons.people_outline_rounded,
                              size: 20,
                              color: Color(0xFFB07818),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Discussion forum',
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                    fontFamily: 'Figtree',
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Learn with classmates',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.ink2,
                                    fontFamily: 'Figtree',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF0D5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Soon',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF9E6814),
                                fontFamily: 'Figtree',
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildStep(String number, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFD5EFE6),
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E6B63),
              fontFamily: 'Figtree',
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            color: AppColors.ink2,
            fontFamily: 'Figtree',
          ),
        ),
      ],
    );
  }

  Widget _buildTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 114,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1512302E),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative background circle
            Positioned(
              right: -24,
              bottom: -32,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
            ),

            // Arrow button
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.65),
                ),
                child: const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.ink),
              ),
            ),

            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(child: icon),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
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
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.ink2,
                        fontFamily: 'Figtree',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationItem({
    required BuildContext context,
    required String initials,
    required Color initialsBg,
    required Color initialsColor,
    required String title,
    required String subtitle,
    required String time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: initialsBg,
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: initialsColor,
                  fontFamily: 'Figtree',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                      letterSpacing: -0.2,
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
            Text(
              time,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.ink3,
                fontFamily: 'Figtree',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

