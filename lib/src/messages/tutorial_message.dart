import 'package:flutter/material.dart';
import 'package:tutorial/src/tutorial.dart';

import 'message.dart';

class TutorialMessage extends Message {
  const TutorialMessage({
    super.message,
    required this.child,
    this.tutorialMessageConfig,
  });

  final Widget child;
  final TutorialMessageConfig? tutorialMessageConfig;
}
