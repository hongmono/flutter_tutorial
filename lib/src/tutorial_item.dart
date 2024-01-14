import 'package:flutter/material.dart';

class TutorialItem extends StatelessWidget {
  const TutorialItem({required super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
