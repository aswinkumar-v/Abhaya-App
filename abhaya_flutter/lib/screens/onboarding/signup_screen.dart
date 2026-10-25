import 'package:flutter/material.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';
import 'login_screen.dart'; // For GoogleIcon

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              // Top Bar with Back Button and Centered Step 1 of 3 Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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

                  // Step Indicator
                  Column(
                    children: [
                      const Text(
                        'Step 1 of 3',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                          fontFamily: 'Figtree',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildStepBar(isActive: true),
                          const SizedBox(width: 6),
                          _buildStepBar(isActive: false),
                          const SizedBox(width: 6),
                          _buildStepBar(isActive: false),
                        ],
                      ),
                    ],
                  ),

                  // Placeholder for symmetry
                  const SizedBox(width: 44),
                ],
              ),

              const SizedBox(height: 18),

              // Title Headline
              const Text(
                'Create your account',
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
                'it takes under a minute',
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
                    _buildField(
                      label: 'Full name',
                      placeholder: 'Your name',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      label: 'Email',
                      placeholder: 'you@college.edu',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      label: 'Password',
                      placeholder: 'At least 8 characters',
                      controller: _passwordController,
                      isPassword: true,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      label: 'Confirm password',
                      placeholder: 'Type it again',
                      controller: _confirmPasswordController,
                      isPassword: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Continue Button
              GestureDetector(
                onTap: () {
                  final name = _nameController.text.trim();
                  final email = _emailController.text.trim();
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter your full name'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  UserService.instance.signup(
                    name: name,
                    userEmail: email.isNotEmpty ? email : '$name@college.edu',
                  );
                  Navigator.pushNamed(context, '/profile-setup');
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Continue',
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

              // Sign up with Google Button
              GestureDetector(
                onTap: () {
                  UserService.instance.login(
                    userEmail: 'student@college.edu',
                    fallbackName: 'Student Nurse',
                  );
                  Navigator.pushNamed(context, '/profile-setup');
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
                        'Sign up with Google',
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

              const SizedBox(height: 28),

              // Bottom Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Have an account? ',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF7E908B),
                      fontFamily: 'Figtree',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text(
                      'Sign in',
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

  Widget _buildStepBar({required bool isActive}) {
    return Container(
      width: 28,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1E6B63) : Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: !isActive ? Border.all(color: const Color(0xFFE2EAE7)) : null,
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String placeholder,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
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
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.ink,
              fontFamily: 'Figtree',
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(
                color: Color(0xFF8E9F9A),
                fontSize: 15,
                fontFamily: 'Figtree',
              ),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
