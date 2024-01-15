import 'package:flutter/material.dart';

class RightTriangle extends StatelessWidget {
  const RightTriangle({
    super.key,
    this.backgroundColor = Colors.white,
  });

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RightTrianglePainter(
        backgroundColor: backgroundColor,
      ),
    );
  }
}

class RightTrianglePainter extends CustomPainter {
  const RightTrianglePainter({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, 0); // 왼쪽 위
    path.lineTo(size.width, size.height / 2); // 꼭대기
    path.lineTo(0, size.height); // 왼쪽 아래
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
