import 'package:flutter/material.dart';
import 'package:tutorial/src/triangles/upper_triangle.dart';

class LeftTriangle extends StatelessWidget {
  const LeftTriangle({
    super.key,
    this.backgroundColor = Colors.white,
  });

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 270 * 3.14 / 180,
      child: CustomPaint(
        painter: UpperTrianglePainter(
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}
