import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/abhaya_scaffold.dart';
import '../../core/widgets/pill_button.dart';

class GenerateDiagramScreen extends StatefulWidget {
  const GenerateDiagramScreen({super.key});

  @override
  State<GenerateDiagramScreen> createState() => _GenerateDiagramScreenState();
}

class _GenerateDiagramScreenState extends State<GenerateDiagramScreen> {
  final _promptController = TextEditingController(text: 'Renal corpuscle with Bowman capsule and glomerulus');
  bool _isGenerating = false;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _generate() {
    setState(() => _isGenerating = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/diagram-result');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AbhayaScaffold(
      title: 'AI Diagram Generator',
      subtitle: 'Create Custom Anatomical Illustrations',
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextStyles.twoToneHeadline(
                main: 'Describe the organ or cycle',
                secondary: 'get an interactive labeled model',
                fontSize: 22,
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Prompt Description', style: AppTextStyles.caption),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _promptController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'e.g. Action potential graph of a cardiac muscle fiber with phases 0 to 4...',
                        hintStyle: TextStyle(color: AppColors.mute, fontSize: 13),
                        filled: true,
                        fillColor: AppColors.bg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Text('Popular Prompts', style: AppTextStyles.caption),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildPromptChip('Circle of Willis cerebral arteries'),
                  _buildPromptChip('Spinal cord cross section & reflex arc'),
                  _buildPromptChip('Tracheobronchial branching tree'),
                ],
              ),

              const Spacer(),

              PillButton(
                text: _isGenerating ? 'Generating Labels...' : 'Generate Interactive Diagram',
                icon: Icons.auto_awesome_rounded,
                height: 52,
                onTap: _isGenerating ? () {} : _generate,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromptChip(String text) {
    return ActionChip(
      label: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.ink)),
      backgroundColor: Colors.white,
      side: const BorderSide(color: AppColors.line),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onPressed: () {
        setState(() => _promptController.text = text);
      },
    );
  }
}
