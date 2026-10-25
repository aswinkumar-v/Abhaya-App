import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(child: Text('Notes', style: TextStyle(color: AppColors.ink, fontFamily: 'Figtree'))),
    );
  }
}
