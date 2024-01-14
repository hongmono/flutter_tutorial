import 'package:flutter/material.dart';

import 'message.dart';

class TutorialItemMessage extends Message {
  const TutorialItemMessage({
    required this.targetKey,
    this.foregroundColor,
    super.message,
  });

  final GlobalKey targetKey;
  final Color? foregroundColor;
}
