import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AbhayaBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AbhayaBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_rounded, 'Home'),
            _buildNavItem(1, Icons.auto_stories_rounded, 'Learn'),
            _buildCenterOrb(2),
            _buildNavItem(3, Icons.assignment_turned_in_rounded, 'Exams'),
            _buildNavItem(4, Icons.favorite_rounded, 'Wellbeing'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.mint : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 22,
              color: isSelected ? AppColors.teal : AppColors.ink3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.teal : AppColors.ink3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterOrb(int index) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Transform.translate(
        offset: const Offset(0, -10),
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2EA396), Color(0xFF1E6B63), Color(0xFF134540)],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.teal.withOpacity(0.38),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.forum_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
