import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _orbController;
  late Animation<double> _fadeAnim;
  late Animation<double> _orbAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _orbController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _orbAnim = Tween<double>(begin: 0.9, end: 1.05).animate(CurvedAnimation(parent: _orbController, curve: Curves.easeInOut));
    Future.delayed(const Duration(milliseconds: 300), () => _fadeController.forward());
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D2826), Color(0xFF153330), Color(0xFF1B4B44)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Orb
                  AnimatedBuilder(
                    animation: _orbAnim,
                    builder: (context, _) {
                      return Transform.scale(
                        scale: _orbAnim.value,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                const Color(0xFF8FDCC0).withOpacity(0.9),
                                const Color(0xFF4DB39E).withOpacity(0.6),
                                const Color(0xFF2A7A70).withOpacity(0.3),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4DB39E).withOpacity(0.4),
                                blurRadius: 60,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'A',
                              style: TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Figtree',
                                shadows: [Shadow(color: Colors.black26, blurRadius: 10)],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    'Abhaya',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'Figtree',
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your nursing buddy.\nAI-powered. Built with care.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF9BCFBC),
                      height: 1.4,
                      fontFamily: 'Figtree',
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Feature pills
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: const [
                      _FeaturePill('📚 Smart Notes'),
                      _FeaturePill('🏥 Clinical Cases'),
                      _FeaturePill('💬 AI Chat'),
                      _FeaturePill('💚 Wellbeing'),
                      _FeaturePill('📝 Mock Exams'),
                    ],
                  ),

                  const Spacer(flex: 2),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/name-setup'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4DB39E),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Figtree'),
                      ),
                      child: const Text('Get Started'),
                    ),
                  ),

                  const SizedBox(height: 14),

                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/home'),
                    child: const Text(
                      'Already have an account? Sign in',
                      style: TextStyle(color: Color(0xFF9BCFBC), fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
}

class _FeaturePill extends StatelessWidget {
  final String text;
  const _FeaturePill(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.white, fontFamily: 'Figtree')),
    );
  }
}
