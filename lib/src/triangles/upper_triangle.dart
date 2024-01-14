import 'package:flutter/material.dart';

class UpperTriangle extends StatelessWidget {
  const UpperTriangle({
    super.key,
    this.backgroundColor = Colors.white,
  });

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: UpperTrianglePainter(
        backgroundColor: backgroundColor,
      ),
    );
  }
}

class UpperTrianglePainter extends CustomPainter {
  const UpperTrianglePainter({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width, size.height); // 오른쪽 아래
    path.lineTo(size.width / 2, 0); // 꼭대기
    path.lineTo(0, size.height); // 왼쪽 아래
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
