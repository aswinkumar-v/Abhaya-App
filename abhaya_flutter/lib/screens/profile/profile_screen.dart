import 'package:flutter/material.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/nurse_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showLogoutDialog = false;
  bool _showPrivacy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: ListenableBuilder(
        listenable: UserService.instance,
        builder: (context, _) => SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Action Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ID Badge Capsule
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                      children: [
                        const Icon(
                          Icons.badge_outlined,
                          size: 15,
                          color: AppColors.ink,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          UserService.instance.studentId.isNotEmpty
                              ? 'ID ${UserService.instance.studentId}'
                              : 'ID Pending',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                            fontFamily: 'Figtree',
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Edit Profile Button
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/edit-profile'),
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
                        child: Icon(Icons.edit_outlined, size: 19, color: AppColors.ink),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Title Headline
              Text(
                'Hi, ${UserService.instance.greetingName}',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  letterSpacing: -0.5,
                  fontFamily: 'Figtree',
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                "here's your journey so far",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7E908B),
                  letterSpacing: -0.3,
                  fontFamily: 'Figtree',
                ),
              ),

              const SizedBox(height: 16),

              // User Info Card
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/edit-profile'),
                child: Container(
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
                  child: Row(
                    children: [
                      const NurseAvatar(size: 58),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              UserService.instance.fullName.isNotEmpty
                                  ? UserService.instance.fullName
                                  : 'Student Nurse',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                                letterSpacing: -0.3,
                                fontFamily: 'Figtree',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${UserService.instance.degree} · Sem ${UserService.instance.semester}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF7E908B),
                                fontFamily: 'Figtree',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE6ECEA)),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // 3 Stats Cards Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      label: 'Day streak',
                      value: '${UserService.instance.streakDays}',
                      bg: const Color(0xFFFDE89C),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      label: 'This month',
                      value: '${UserService.instance.studyHoursThisWeek}h',
                      bg: const Color(0xFFC7EBE2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      label: 'Progress',
                      value: '${UserService.instance.examReadiness}%',
                      bg: const Color(0xFFF7C2B4),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // "How Abhaya knows you" Card
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'How Abhaya knows you',
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                            letterSpacing: -0.3,
                            fontFamily: 'Figtree',
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/interests'),
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                              fontFamily: 'Figtree',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Chips layout
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...UserService.instance.focusTopics.map(
                          (topic) => _InterestChip(
                            label: topic,
                            bg: const Color(0xFFEEF2F0),
                            textColor: AppColors.ink,
                          ),
                        ),
                        _InterestChip(
                          label: UserService.instance.learningStyle,
                          bg: const Color(0xFFECE7FA),
                          textColor: const Color(0xFF745FB6),
                        ),
                        _InterestChip(
                          label: '${UserService.instance.dailyStudyTime} a day',
                          bg: const Color(0xFFFEF2D0),
                          textColor: const Color(0xFF9E6D18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Settings Section Header
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  letterSpacing: -0.3,
                  fontFamily: 'Figtree',
                ),
              ),
              const SizedBox(height: 12),

              // Settings Group Container
              Container(
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
                  children: [
                    _buildSettingsRow(
                      icon: Icons.check_box_outlined,
                      iconBg: const Color(0xFFECE7FA),
                      iconColor: const Color(0xFF7E66C4),
                      title: 'Exam history',
                      subtitle: 'Your mock results',
                      onTap: () => Navigator.pushNamed(context, '/exam-history'),
                    ),
                    _buildDivider(),
                    _buildSettingsRow(
                      icon: Icons.grid_view_rounded,
                      iconBg: const Color(0xFFFDEEE9),
                      iconColor: const Color(0xFFD46950),
                      title: 'Saved diagrams',
                      subtitle: 'Labelled and generated',
                      onTap: () => Navigator.pushNamed(context, '/diagram-history'),
                    ),
                    _buildDivider(),
                    _buildSettingsRow(
                      icon: Icons.notifications_none_rounded,
                      iconBg: const Color(0xFFFFF4D6),
                      iconColor: const Color(0xFFC29124),
                      title: 'Notifications',
                      subtitle: 'Reminders and updates',
                      onTap: () => Navigator.pushNamed(context, '/notifications'),
                    ),
                    _buildDivider(),
                    _buildSettingsRow(
                      icon: Icons.lock_outline_rounded,
                      iconBg: const Color(0xFFE2F1F8),
                      iconColor: const Color(0xFF388697),
                      title: 'Privacy and data',
                      subtitle: 'Private to you',
                      onTap: () => setState(() => _showPrivacy = !_showPrivacy),
                    ),
                    if (_showPrivacy)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7FAF9),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE5EDE9)),
                          ),
                          child: const Text(
                            'Your chats, journal and mood check-ins are private to you. Faculty only see what you choose to share.',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: AppColors.ink2,
                              height: 1.5,
                              fontFamily: 'Figtree',
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Logout Dialog or Button
              if (_showLogoutDialog)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFE7EDEB)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Log out of Abhaya?',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                          fontFamily: 'Figtree',
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Your notes and progress stay saved.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF7E908B),
                          fontFamily: 'Figtree',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _showLogoutDialog = false),
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF2F0),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Stay',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                    fontFamily: 'Figtree',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                UserService.instance.resetForNewUser();
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/welcome',
                                  (r) => false,
                                );
                              },
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD44538),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Log out',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontFamily: 'Figtree',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else
                GestureDetector(
                  onTap: () => setState(() => _showLogoutDialog = true),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: const Color(0xFFE6ECEA)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.logout_rounded,
                          size: 18,
                          color: Color(0xFFD44538),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Log out',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFD44538),
                            fontFamily: 'Figtree',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color bg,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/progress'),
      child: Container(
        height: 86,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.ink2,
                fontFamily: 'Figtree',
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
                letterSpacing: -0.5,
                fontFamily: 'Figtree',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Center(
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7E908B),
                      fontFamily: 'Figtree',
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: Color(0xFF9EAFAA),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFEFF3F1),
      indent: 68,
      endIndent: 16,
    );
  }
}

class _InterestChip extends StatelessWidget {
  final String label;
  final Color bg;
  final Color textColor;

  const _InterestChip({
    required this.label,
    required this.bg,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: textColor,
          fontFamily: 'Figtree',
        ),
      ),
    );
  }
}
