import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use existing chat_centre_screen content
    return const _ChatCentre();
  }
}

class _ChatCentre extends StatelessWidget {
  const _ChatCentre();

  @override
  Widget build(BuildContext context) {
    final characters = [
      {'name': 'Veena', 'role': 'Senior Nurse Mentor', 'emoji': '👩‍⚕️', 'color': AppColors.teal, 'bg': const Color(0xFFDFF4EE)},
      {'name': 'Dr. Arjun', 'role': 'Physician Coach', 'emoji': '👨‍⚕️', 'color': const Color(0xFF8A7FCA), 'bg': const Color(0xFFEEECF9)},
      {'name': 'Fuss', 'role': 'Your study buddy', 'emoji': '🐾', 'color': const Color(0xFFE07B8B), 'bg': const Color(0xFFFAEEF0)},
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('Chat Centre', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.ink, letterSpacing: -0.5, fontFamily: 'Figtree')),
              const Text('Talk, practise, and reflect', style: TextStyle(fontSize: 14, color: AppColors.ink3, fontFamily: 'Figtree')),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: characters.length,
                  itemBuilder: (context, i) {
                    final c = characters[i];
                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/chat', arguments: {'character': c['name']}),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: c['bg'] as Color,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: (c['color'] as Color).withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: (c['color'] as Color).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(child: Text(c['emoji'] as String, style: const TextStyle(fontSize: 26))),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c['name'] as String, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: c['color'] as Color, fontFamily: 'Figtree')),
                                  Text(c['role'] as String, style: const TextStyle(fontSize: 13, color: AppColors.ink3, fontFamily: 'Figtree')),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: c['color'] as Color),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
