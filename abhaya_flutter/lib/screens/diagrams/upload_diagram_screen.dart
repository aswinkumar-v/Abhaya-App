import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/abhaya_scaffold.dart';
import '../../core/widgets/pill_button.dart';

class UploadDiagramScreen extends StatefulWidget {
  const UploadDiagramScreen({super.key});

  @override
  State<UploadDiagramScreen> createState() => _UploadDiagramScreenState();
}

class _UploadDiagramScreenState extends State<UploadDiagramScreen> {
  bool _uploaded = false;

  @override
  Widget build(BuildContext context) {
    return AbhayaScaffold(
      title: 'Upload Diagram',
      subtitle: 'AI Recognition & Labeling',
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextStyles.twoToneHeadline(
                main: 'Snap your textbook',
                secondary: 'we turn it into an interactive quiz',
                fontSize: 22,
              ),
              const SizedBox(height: 20),

              // Upload Box
              GestureDetector(
                onTap: () {
                  setState(() => _uploaded = true);
                },
                child: Container(
                  height: 240,
                  decoration: BoxDecoration(
                    color: _uploaded ? AppColors.mint2 : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _uploaded ? AppColors.teal : const Color(0xFFA9C6BE),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: _uploaded ? AppColors.teal : AppColors.track,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _uploaded ? Icons.check_circle_rounded : Icons.camera_alt_rounded,
                            color: _uploaded ? Colors.white : AppColors.teal,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _uploaded ? 'Nephron_Drawing.jpg attached' : 'Tap to take photo or choose file',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _uploaded ? 'Ready for AI anatomical parsing' : 'Supports JPG, PNG, PDF up to 10MB',
                          style: const TextStyle(fontSize: 12, color: AppColors.ink3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),

              PillButton(
                text: _uploaded ? 'Analyze & Start Label Drill' : 'Select Photo First',
                height: 52,
                backgroundColor: _uploaded ? AppColors.teal : AppColors.mute,
                onTap: () {
                  if (_uploaded) {
                    Navigator.pushReplacementNamed(context, '/diagram-result');
                  } else {
                    setState(() => _uploaded = true);
                  }
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
