import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/pill_button.dart';

class AiAiChatScreen extends StatelessWidget {
  const AiAiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(child: Text('AI-AI Chat', style: TextStyle(color: AppColors.ink))),
    );
  }
}
