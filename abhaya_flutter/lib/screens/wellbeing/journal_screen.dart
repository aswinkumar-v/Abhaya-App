import 'package:flutter/material.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/abhaya_scaffold.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _draftController = TextEditingController();
  String _selectedTag = 'Grateful';

  final List<String> _tags = ['Grateful', 'Proud', 'Anxious', 'Tired'];

  void _saveEntry() {
    final text = _draftController.text.trim();
    if (text.isEmpty) return;

    UserService.instance.addJournalEntry(tag: _selectedTag, text: text);
    _draftController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Journal entry saved privately'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _draftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserService.instance,
      builder: (context, _) {
        final user = UserService.instance;
        final entries = user.journalEntries;

        return AbhayaScaffold(
          title: 'Journal',
          subtitle: 'Private to you',
          backgroundColor: const Color(0xFFF9F7F3), // sand background
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header title
                  AppTextStyles.twoToneHeadline(
                    main: 'Saturday, 17 Oct',
                    secondary: "what's on your mind?",
                    fontSize: 22,
                  ),
                  const SizedBox(height: 16),

                  // Mood chips
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _tags.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final tag = _tags[i];
                        final isSelected = tag == _selectedTag;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedTag = tag),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.deep : Colors.white,
                              borderRadius: BorderRadius.circular(19),
                              border: Border.all(
                                color: isSelected ? AppColors.deep : const Color(0xFFE2DDD5),
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.deep.withValues(alpha: 0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : AppColors.ink,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Draft card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F2EC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "Today's entry",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink),
                              ),
                            ),
                            Text(
                              'Feeling ${_selectedTag.toLowerCase()}',
                              style: const TextStyle(fontSize: 12, color: AppColors.ink3, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _draftController,
                          maxLines: 4,
                          style: const TextStyle(fontSize: 15, color: AppColors.ink, height: 1.4),
                          decoration: const InputDecoration(
                            hintText: 'Write freely. Reflections on clinicals, exams, or life...',
                            hintStyle: TextStyle(color: AppColors.ink3, fontSize: 14),
                            border: InputBorder.none,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Saved privately on this device',
                              style: TextStyle(fontSize: 11, color: AppColors.ink3),
                            ),
                            ElevatedButton(
                              onPressed: _saveEntry,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.deep,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                elevation: 0,
                              ),
                              child: const Text('Save entry', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // My journal section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('My journal', style: AppTextStyles.h3),
                      Row(
                        children: [
                          const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.ink3),
                          const SizedBox(width: 4),
                          Text('${entries.length} entries', style: const TextStyle(fontSize: 12, color: AppColors.ink3, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (entries.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2DDD5)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8F4F2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit_note_rounded, color: AppColors.teal, size: 24),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No journal entries yet',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Take a deep breath, type your thoughts above, and tap "Save entry".',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12.5, color: AppColors.ink2),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: entries.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final e = entries[i];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFBF4D9),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      e.tag,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF8A6A12),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    e.date,
                                    style: const TextStyle(fontSize: 12, color: AppColors.ink3),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                e.text,
                                style: const TextStyle(fontSize: 14, color: AppColors.ink, height: 1.4),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
