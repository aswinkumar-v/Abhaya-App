import 'package:flutter/material.dart';

/// Exact SVG icons matching Home.dc.html (line 159)

class NotesBuddyIcon extends StatelessWidget {
  final double size;
  final Color color;

  const NotesBuddyIcon({super.key, this.size = 20, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _NotesBuddyPainter(color: color),
    );
  }
}

class _NotesBuddyPainter extends CustomPainter {
  final Color color;
  _NotesBuddyPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24.0;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final docPath = Path()
      ..moveTo(7 * s, 3.5 * s)
      ..lineTo(14 * s, 3.5 * s)
      ..lineTo(18 * s, 7.5 * s)
      ..lineTo(18 * s, 20 * s)
      ..quadraticBezierTo(18 * s, 20.5 * s, 17.5 * s, 20.5 * s)
      ..lineTo(7 * s, 20.5 * s)
      ..quadraticBezierTo(6.5 * s, 20.5 * s, 6.5 * s, 20 * s)
      ..lineTo(6.5 * s, 4 * s)
      ..quadraticBezierTo(6.5 * s, 3.5 * s, 7 * s, 3.5 * s);
    canvas.drawPath(docPath, stroke);

    // Fold corner
    final fold = Path()
      ..moveTo(14 * s, 3.5 * s)
      ..lineTo(14 * s, 8 * s)
      ..lineTo(18 * s, 8 * s);
    canvas.drawPath(fold, stroke);

    // Text lines
    canvas.drawLine(Offset(9.5 * s, 12.5 * s), Offset(15 * s, 12.5 * s), stroke);
    canvas.drawLine(Offset(9.5 * s, 16 * s), Offset(13.5 * s, 16 * s), stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DiagramTrainerIcon extends StatelessWidget {
  final double size;
  final Color color;

  const DiagramTrainerIcon({super.key, this.size = 20, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _DiagramTrainerPainter(color: color),
    );
  }
}

class _DiagramTrainerPainter extends CustomPainter {
  final Color color;
  _DiagramTrainerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24.0;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Top-left: rounded square
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(3.5 * s, 3.5 * s, 7 * s, 7 * s),
        Radius.circular(2 * s),
      ),
      stroke,
    );

    // Top-right: circle
    canvas.drawCircle(Offset(17 * s, 7 * s), 3.5 * s, stroke);

    // Bottom-left: triangle
    final tri = Path()
      ..moveTo(7 * s, 14 * s)
      ..lineTo(10.5 * s, 20.5 * s)
      ..lineTo(3.5 * s, 20.5 * s)
      ..close();
    canvas.drawPath(tri, stroke);

    // Bottom-right: square
    canvas.drawRect(Rect.fromLTWH(14 * s, 14 * s, 6.5 * s, 6.5 * s), stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ClinicalCasesIcon extends StatelessWidget {
  final double size;
  final Color color;

  const ClinicalCasesIcon({super.key, this.size = 20, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ClinicalCasesPainter(color: color),
    );
  }
}

class _ClinicalCasesPainter extends CustomPainter {
  final Color color;
  _ClinicalCasesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24.0;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // ECG heartbeat pulse: M3 12h4l2-5 3 10 2-5h7
    final ecg = Path()
      ..moveTo(3 * s, 12 * s)
      ..lineTo(7 * s, 12 * s)
      ..lineTo(9 * s, 7 * s)
      ..lineTo(12 * s, 17 * s)
      ..lineTo(14 * s, 12 * s)
      ..lineTo(21 * s, 12 * s);
    canvas.drawPath(ecg, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MockExamsIcon extends StatelessWidget {
  final double size;
  final Color color;

  const MockExamsIcon({super.key, this.size = 20, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _MockExamsPainter(color: color),
    );
  }
}

class _MockExamsPainter extends CustomPainter {
  final Color color;
  _MockExamsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24.0;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Clipboard body: rect x=5 y=4.5 w=14 h=16 rx=2.5
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(5 * s, 4.5 * s, 14 * s, 16 * s),
        Radius.circular(2.5 * s),
      ),
      stroke,
    );

    // Top clip: M9 4.5V3.5h6v1
    final clip = Path()
      ..moveTo(9 * s, 4.5 * s)
      ..lineTo(9 * s, 3.2 * s)
      ..lineTo(15 * s, 3.2 * s)
      ..lineTo(15 * s, 4.5 * s);
    canvas.drawPath(clip, stroke);

    // Checkmark: M9 13l2 2 4-4
    final check = Path()
      ..moveTo(9 * s, 13 * s)
      ..lineTo(11 * s, 15 * s)
      ..lineTo(15 * s, 10.5 * s);
    canvas.drawPath(check, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
