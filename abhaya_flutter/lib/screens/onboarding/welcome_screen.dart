import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/welcome_stage.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 18),

            // Top Brand Pill: "Abhaya · Nursing buddy"
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE8EEEC)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF12302E).withValues(alpha: 0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          center: Alignment(-0.3, -0.4),
                          radius: 0.8,
                          colors: [Color(0xFF5CC2B2), Color(0xFF14564F)],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Abhaya · Nursing buddy',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Center Stage with Glowing Halo, Spinning 12-Dot Constellation Ring, and Fuss Mascot
            const Expanded(
              child: Center(
                child: WelcomeStage(size: 260),
              ),
            ),

            // Bottom Welcome Content & Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Headline: "Learn like the nurse / you're becoming"
                  const Text(
                    'Learn like the nurse',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                      letterSpacing: -0.6,
                      height: 1.15,
                      fontFamily: 'Figtree',
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "you're becoming",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF7E908B),
                      letterSpacing: -0.4,
                      fontFamily: 'Figtree',
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtitle description
                  const Text(
                    'Practise real cases, prepare for exams and take care of yourself, at your own pace.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF5A706B),
                      height: 1.45,
                      fontFamily: 'Figtree',
                    ),
                  ),

                  const SizedBox(height: 24),

                  // "Get started →" Primary Button
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/signup'),
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22645B),
                        borderRadius: BorderRadius.circular(27),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF22645B).withValues(alpha: 0.28),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Get started',
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFamily: 'Figtree',
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // "I have an account" Secondary Button
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/login'),
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(27),
                        border: Border.all(
                          color: const Color(0xFFE2EAE7),
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'I have an account',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
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
    );
  }
}

