import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class DiagramScreen extends StatelessWidget {
  const DiagramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(child: Text('Diagram', style: TextStyle(color: AppColors.ink, fontFamily: 'Figtree'))),
    );
  }
}
