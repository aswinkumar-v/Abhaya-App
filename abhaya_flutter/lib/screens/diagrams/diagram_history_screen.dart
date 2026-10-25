import 'package:flutter/material.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/abhaya_scaffold.dart';

class DiagramHistoryScreen extends StatefulWidget {
  const DiagramHistoryScreen({super.key});

  @override
  State<DiagramHistoryScreen> createState() => _DiagramHistoryScreenState();
}

class _DiagramHistoryScreenState extends State<DiagramHistoryScreen> {
  String _selectedTab = 'All';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserService.instance,
      builder: (context, _) {
        final user = UserService.instance;
        final allDiagrams = user.savedDiagrams;
        final filtered = allDiagrams
            .where((d) => _selectedTab == 'All' || d.type == _selectedTab)
            .toList();

        return AbhayaScaffold(
          title: 'History',
          subtitle: 'Diagram trainer',
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextStyles.twoToneHeadline(
                    main: 'Diagram history',
                    secondary: "Everything you've created.",
                    fontSize: 22,
                  ),
                  const SizedBox(height: 16),

                  // Segmented Filter
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.track,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: ['All', 'Uploaded', 'Generated'].map((tab) {
                        final isSel = tab == _selectedTab;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedTab = tab),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSel ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: isSel
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        )
                                      ]
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                tab,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                  color: isSel ? AppColors.ink : AppColors.ink3,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$_selectedTab diagrams', style: AppTextStyles.h3),
                      Text('${filtered.length} saved', style: AppTextStyles.meta),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (filtered.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE6ECEA)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEAF5F1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.architecture_rounded, color: AppColors.teal, size: 26),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'No diagrams saved yet',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Use the diagram trainer to draw or generate medical anatomy diagrams.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12.5, color: AppColors.ink2),
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, '/diagram-trainer'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            child: const Text('Open diagram trainer', style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    )
                  else
                    // 2-column Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, i) {
                        final d = filtered[i];
                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/diagram-result'),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: const Color(0xFFDCF0EA),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 8,
                                          top: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: 0.85),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              d.type,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.ink2,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Center(
                                          child: Icon(
                                            Icons.hub_rounded,
                                            size: 38,
                                            color: AppColors.teal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        d.title,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.ink,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        d.timeAgo,
                                        style: const TextStyle(fontSize: 12, color: AppColors.ink3),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
