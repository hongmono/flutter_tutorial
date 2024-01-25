import 'package:flutter/material.dart';
import 'package:tutorial/src/triangles/upper_triangle.dart';

class DownTriangle extends StatelessWidget {
  const DownTriangle({
    super.key,
    this.backgroundColor = Colors.white,
  });

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 180 * 3.14 / 180,
      child: CustomPaint(
        painter: UpperTrianglePainter(
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}
