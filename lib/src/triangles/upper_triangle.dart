import 'dart:math';

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

    double a = size.width / 2;
    double b = size.height;
    double r = 2;

    double p = (b * r) / sqrt(b * b + a * a);
    double q = -(b * b * sqrt(b * b + a * a) * r - a * b * b * b - a * a * a * b) / (a * b * b + a * a * a);

    final path = Path();
    path.moveTo(a + a, size.height); // 오른쪽 아래
    path.lineTo(a + p, size.height - q);
    path.arcToPoint(Offset(a - p, size.height - q), radius: Radius.circular(r), clockwise: false);
    path.lineTo(0, size.height); // 왼쪽 아래
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
