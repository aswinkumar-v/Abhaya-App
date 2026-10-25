import 'package:flutter/material.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _sentReset = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar with Circular Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
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
              ),

              const SizedBox(height: 18),

              // Title Headline
              const Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  letterSpacing: -0.5,
                  fontFamily: 'Figtree',
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                "let's keep learning",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7E908B),
                  letterSpacing: -0.3,
                  fontFamily: 'Figtree',
                ),
              ),

              const SizedBox(height: 20),

              // Form Card
              Container(
                padding: const EdgeInsets.all(20),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink2,
                        fontFamily: 'Figtree',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: const Color(0xFFE2EAE7), width: 1.5),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.ink,
                          fontFamily: 'Figtree',
                        ),
                        decoration: const InputDecoration(
                          hintText: 'you@college.edu',
                          hintStyle: TextStyle(
                            color: Color(0xFF8E9F9A),
                            fontSize: 15,
                            fontFamily: 'Figtree',
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink2,
                        fontFamily: 'Figtree',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: const Color(0xFFE2EAE7), width: 1.5),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.ink,
                          fontFamily: 'Figtree',
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Your password',
                          hintStyle: TextStyle(
                            color: Color(0xFF8E9F9A),
                            fontSize: 15,
                            fontFamily: 'Figtree',
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _sentReset = true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Password reset link sent to your email.')),
                          );
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E6B63),
                            fontFamily: 'Figtree',
                          ),
                        ),
                      ),
                    ),

                    if (_sentReset) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF6F3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'We sent a reset link to your email. Check your inbox.',
                          style: TextStyle(fontSize: 12, color: Color(0xFF1E6B63)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Sign in Primary Button
              GestureDetector(
                onTap: () {
                  final email = _emailController.text.trim();
                  UserService.instance.login(
                    userEmail: email.isNotEmpty ? email : 'student@college.edu',
                  );
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22645B),
                    borderRadius: BorderRadius.circular(27),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF22645B).withValues(alpha: 0.28),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // "or" Divider
              Row(
                children: const [
                  Expanded(child: Divider(color: Color(0xFFE2EAE7), thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'or',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8E9F9A),
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Color(0xFFE2EAE7), thickness: 1)),
                ],
              ),

              const SizedBox(height: 16),

              // Continue with Google Secondary Button
              GestureDetector(
                onTap: () {
                  UserService.instance.login(
                    userEmail: 'student@college.edu',
                    fallbackName: 'Student Nurse',
                  );
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(27),
                    border: Border.all(color: const Color(0xFFE2EAE7), width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      GoogleIcon(size: 19),
                      SizedBox(width: 10),
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                          fontFamily: 'Figtree',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Bottom Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'New here? ',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF7E908B),
                      fontFamily: 'Figtree',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/signup'),
                    child: const Text(
                      'Create an account',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E6B63),
                        fontFamily: 'Figtree',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleIcon extends StatelessWidget {
  final double size;
  const GoogleIcon({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleIconPainter(),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24.0;
    // Blue path
    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    final bluePath = Path()
      ..moveTo(21.6 * s, 12.2 * s)
      ..cubicTo(21.6 * s, 11.5 * s, 21.5 * s, 10.8 * s, 21.4 * s, 10.2 * s)
      ..lineTo(12 * s, 10.2 * s)
      ..lineTo(12 * s, 14.0 * s)
      ..lineTo(17.4 * s, 14.0 * s)
      ..cubicTo(17.2 * s, 15.3 * s, 16.4 * s, 16.3 * s, 15.4 * s, 17.0 * s)
      ..lineTo(15.4 * s, 19.5 * s)
      ..lineTo(18.6 * s, 19.5 * s)
      ..cubicTo(20.5 * s, 17.8 * s, 21.6 * s, 15.2 * s, 21.6 * s, 12.2 * s)
      ..close();
    canvas.drawPath(bluePath, bluePaint);

    // Green path
    final greenPaint = Paint()..color = const Color(0xFF34A853);
    final greenPath = Path()
      ..moveTo(12 * s, 22 * s)
      ..cubicTo(14.7 * s, 22 * s, 17 * s, 21.1 * s, 18.6 * s, 19.6 * s)
      ..lineTo(15.4 * s, 17.1 * s)
      ..cubicTo(14.5 * s, 17.7 * s, 13.4 * s, 18.1 * s, 12 * s, 18.1 * s)
      ..cubicTo(9.4 * s, 18.1 * s, 7.2 * s, 16.3 * s, 6.4 * s, 14.0 * s)
      ..lineTo(3.1 * s, 14.0 * s)
      ..lineTo(3.1 * s, 16.6 * s)
      ..cubicTo(4.7 * s, 19.8 * s, 8.1 * s, 22 * s, 12 * s, 22 * s)
      ..close();
    canvas.drawPath(greenPath, greenPaint);

    // Yellow path
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    final yellowPath = Path()
      ..moveTo(6.4 * s, 14.0 * s)
      ..cubicTo(6.2 * s, 13.4 * s, 6.1 * s, 12.7 * s, 6.1 * s, 12.0 * s)
      ..cubicTo(6.1 * s, 11.3 * s, 6.2 * s, 10.6 * s, 6.4 * s, 10.0 * s)
      ..lineTo(6.4 * s, 7.4 * s)
      ..lineTo(3.1 * s, 7.4 * s)
      ..cubicTo(2.4 * s, 8.8 * s, 2.0 * s, 10.4 * s, 2.0 * s, 12.0 * s)
      ..cubicTo(2.0 * s, 13.6 * s, 2.4 * s, 15.2 * s, 3.1 * s, 16.6 * s)
      ..lineTo(6.4 * s, 14.0 * s)
      ..close();
    canvas.drawPath(yellowPath, yellowPaint);

    // Red path
    final redPaint = Paint()..color = const Color(0xFFEA4335);
    final redPath = Path()
      ..moveTo(12 * s, 5.9 * s)
      ..cubicTo(13.5 * s, 5.9 * s, 14.8 * s, 6.4 * s, 15.8 * s, 7.4 * s)
      ..lineTo(18.7 * s, 4.5 * s)
      ..cubicTo(16.9 * s, 2.8 * s, 14.7 * s, 2.0 * s, 12 * s, 2.0 * s)
      ..cubicTo(8.1 * s, 2.0 * s, 4.7 * s, 4.2 * s, 3.1 * s, 7.4 * s)
      ..lineTo(6.4 * s, 10.0 * s)
      ..cubicTo(7.2 * s, 7.7 * s, 9.4 * s, 5.9 * s, 12 * s, 5.9 * s)
      ..close();
    canvas.drawPath(redPath, redPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
