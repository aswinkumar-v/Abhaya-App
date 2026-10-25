import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/pill_button.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final _controller = TextEditingController();
  bool get _hasName => _controller.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const Spacer(),
              const Text('What\'s your name?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.ink, letterSpacing: -0.8, fontFamily: 'Figtree')),
              const SizedBox(height: 8),
              const Text('Abhaya will use this to personalize your experience.', style: TextStyle(fontSize: 15, color: AppColors.ink3, fontFamily: 'Figtree')),
              const SizedBox(height: 32),
              TextField(
                controller: _controller,
                onChanged: (_) => setState(() {}),
                autofocus: true,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.ink, fontFamily: 'Figtree'),
                decoration: InputDecoration(
                  hintText: 'Your first name…',
                  hintStyle: const TextStyle(color: AppColors.ink3, fontFamily: 'Figtree'),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: AppColors.line),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: AppColors.teal, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                ),
              ),
              const Spacer(flex: 2),
              AnimatedOpacity(
                opacity: _hasName ? 1.0 : 0.4,
                duration: const Duration(milliseconds: 200),
                child: PillButton(
                  text: _hasName ? 'Nice to meet you, ${_controller.text.trim().split(' ').first}! →' : 'Continue',
                  onTap: _hasName ? () => Navigator.pushNamed(context, '/interests') : () {},
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
