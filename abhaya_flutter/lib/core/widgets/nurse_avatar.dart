import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../services/user_service.dart';

/// Dynamic User Avatar that displays the user's uploaded photo,
/// or falls back to the authentic nurse avatar illustration.
class NurseAvatar extends StatelessWidget {
  final double size;
  final Uint8List? imageBytes;
  final bool listenToUserService;

  const NurseAvatar({
    super.key,
    this.size = 36,
    this.imageBytes,
    this.listenToUserService = true,
  });

  @override
  Widget build(BuildContext context) {
    if (listenToUserService) {
      return ListenableBuilder(
        listenable: UserService.instance,
        builder: (context, _) {
          final bytes = imageBytes ?? UserService.instance.profileImageBytes;
          return _buildAvatarContainer(bytes);
        },
      );
    } else {
      return _buildAvatarContainer(imageBytes);
    }
  }

  Widget _buildAvatarContainer(Uint8List? bytes) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipOval(
        child: bytes != null && bytes.isNotEmpty
            ? Image.memory(
                bytes,
                width: size,
                height: size,
                fit: BoxFit.cover,
              )
            : CustomPaint(
                size: Size(size, size),
                painter: _NurseAvatarPainter(),
              ),
      ),
    );
  }
}

class _NurseAvatarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final s = w / 64.0; // scale factor relative to 64x64 SVG viewBox

    // 1. Background gradient
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFBFEBDD), Color(0xFFE7F1EC), Color(0xFFF7D6C4)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // 2. Hair back
    final hairPaint = Paint()..color = const Color(0xFF281D20);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(32 * s, 36 * s),
        width: 38 * s,
        height: 44 * s,
      ),
      hairPaint,
    );

    // 3. Shoulders & Teal Scrubs
    final scrubPaint = Paint()..color = const Color(0xFF1E6B63);
    final scrubPath = Path()
      ..moveTo(10 * s, 64 * s)
      ..quadraticBezierTo(14 * s, 48 * s, 32 * s, 48 * s)
      ..quadraticBezierTo(50 * s, 48 * s, 54 * s, 64 * s)
      ..close();
    canvas.drawPath(scrubPath, scrubPaint);

    // V-neck on scrubs
    final vNeckPaint = Paint()
      ..color = const Color(0xFFE9FBF5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * s
      ..strokeCap = StrokeCap.round;
    final vNeckPath = Path()
      ..moveTo(26 * s, 49 * s)
      ..lineTo(32 * s, 56 * s)
      ..lineTo(38 * s, 49 * s);
    canvas.drawPath(vNeckPath, vNeckPaint);

    // Neck
    final neckPaint = Paint()..color = const Color(0xFFD99E7E);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(32 * s, 46 * s), width: 9 * s, height: 10 * s),
        Radius.circular(3.5 * s),
      ),
      neckPaint,
    );

    // 4. Head / Face
    final facePaint = Paint()..color = const Color(0xFFEDB898);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(32 * s, 34 * s),
        width: 23 * s,
        height: 25 * s,
      ),
      facePaint,
    );

    // Front Hair / Bangs
    final frontHairPath = Path()
      ..moveTo(20.5 * s, 33 * s)
      ..quadraticBezierTo(20.5 * s, 21 * s, 32 * s, 21 * s)
      ..quadraticBezierTo(43.5 * s, 21 * s, 43.5 * s, 33 * s)
      ..quadraticBezierTo(36.5 * s, 26 * s, 32 * s, 26 * s)
      ..quadraticBezierTo(27.5 * s, 26 * s, 20.5 * s, 33 * s)
      ..close();
    canvas.drawPath(frontHairPath, hairPaint);

    // 5. Nurse Cap
    final capPaint = Paint()..color = Colors.white;
    final capPath = Path()
      ..moveTo(22 * s, 23 * s)
      ..quadraticBezierTo(25 * s, 15 * s, 32 * s, 15 * s)
      ..quadraticBezierTo(39 * s, 15 * s, 42 * s, 23 * s)
      ..lineTo(40 * s, 25 * s)
      ..quadraticBezierTo(32 * s, 21 * s, 24 * s, 25 * s)
      ..close();
    canvas.drawPath(capPath, capPaint);

    // Red Cross on cap
    final crossPaint = Paint()
      ..color = const Color(0xFFE05238)
      ..strokeWidth = 1.8 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(32 * s, 17.5 * s), Offset(32 * s, 21.5 * s), crossPaint);
    canvas.drawLine(Offset(30 * s, 19.5 * s), Offset(34 * s, 19.5 * s), crossPaint);

    // 6. Eyes
    final eyePaint = Paint()..color = const Color(0xFF2B1E1E);
    canvas.drawCircle(Offset(27.5 * s, 34.5 * s), 1.5 * s, eyePaint);
    canvas.drawCircle(Offset(36.5 * s, 34.5 * s), 1.5 * s, eyePaint);
    // Eye shines
    final shinePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(27 * s, 34 * s), 0.6 * s, shinePaint);
    canvas.drawCircle(Offset(36 * s, 34 * s), 0.6 * s, shinePaint);

    // Cheeks
    final cheekPaint = Paint()
      ..color = const Color(0xFFF08A84).withValues(alpha: 0.55);
    canvas.drawCircle(Offset(25 * s, 37.5 * s), 2.2 * s, cheekPaint);
    canvas.drawCircle(Offset(39 * s, 37.5 * s), 2.2 * s, cheekPaint);

    // Smile
    final smilePaint = Paint()
      ..color = const Color(0xFF9E4E47)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3 * s
      ..strokeCap = StrokeCap.round;
    final smilePath = Path()
      ..moveTo(29.5 * s, 38.5 * s)
      ..quadraticBezierTo(32 * s, 41 * s, 34.5 * s, 38.5 * s);
    canvas.drawPath(smilePath, smilePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
