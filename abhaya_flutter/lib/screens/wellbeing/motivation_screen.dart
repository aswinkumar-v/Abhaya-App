import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/abhaya_scaffold.dart';
import '../../core/widgets/fuss_avatar.dart';

class MotivationScreen extends StatefulWidget {
  const MotivationScreen({super.key});

  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  int _currentIndex = 0;
  bool _isFavorited = false;

  final List<String> _quotes = [
    'Every patient you’ll ever help is a little safer because you studied tonight.',
    'You don’t have to know everything yet. You just have to keep learning.',
    'Rest is part of the work. A tired nurse can’t pour from an empty cup.',
    'Small steps every day add up to a confident nurse.',
  ];

  void _nextQuote() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _quotes.length;
      _isFavorited = false;
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorited ? 'Saved to your favourite quotes' : 'Removed from favourites'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AbhayaScaffold(
      title: 'Daily motivation',
      subtitle: 'A thought for today',
      backgroundColor: const Color(0xFFFDF6F3), // blush background
      actions: [
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Quote copied to clipboard!'), behavior: SnackBarBehavior.floating),
            );
          },
          icon: const Icon(Icons.share_outlined, color: AppColors.ink),
        ),
      ],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 10),

              // Main Quote Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF09880).withValues(alpha: 0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const FussAvatar(size: 96, mood: FussMood.happy),
                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBE4DC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'FOR YOU TODAY',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: Color(0xFFC0553A),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.1),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        _quotes[_currentIndex],
                        key: ValueKey<int>(_currentIndex),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                          height: 1.45,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Indicator dots and count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: List.generate(_quotes.length, (i) {
                            final isActive = i == _currentIndex;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.only(right: 6),
                              width: isActive ? 22 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: isActive ? AppColors.deep : const Color(0xFFD9E1DF),
                              ),
                            );
                          }),
                        ),
                        Text(
                          'Thought ${_currentIndex + 1} of ${_quotes.length}',
                          style: const TextStyle(fontSize: 12, color: AppColors.ink3, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bottom Actions
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _nextQuote,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.deep,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                            elevation: 0,
                          ),
                          child: const Text(
                            'New thought',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    GestureDetector(
                      onTap: _toggleFavorite,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isFavorited ? const Color(0xFFFDE8E4) : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isFavorited ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                          color: _isFavorited ? const Color(0xFFE24C4C) : AppColors.ink,
                          size: 24,
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
  }
}
