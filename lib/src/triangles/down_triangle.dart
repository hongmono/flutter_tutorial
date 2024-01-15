import 'package:flutter/material.dart';

class DownTriangle extends StatelessWidget {
  const DownTriangle({
    super.key,
    this.backgroundColor = Colors.white,
  });

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DownTrianglePainter(
        backgroundColor: backgroundColor,
      ),
    );
  }
}

class DownTrianglePainter extends CustomPainter {
  const DownTrianglePainter({
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
    path.lineTo(size.width / 2, size.height); // 꼭대기
    path.lineTo(size.width, 0); // 오른쪽 위
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
