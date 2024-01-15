import 'package:flutter/material.dart';
import 'package:tutorial/src/tutorial.dart';

import 'message.dart';

class TutorialItemMessage extends Message {
  const TutorialItemMessage({
    required this.targetKey,
    this.tutorialItemMessageConfig,
    super.message,
  });

  final GlobalKey targetKey;
  final TutorialItemMessageConfig? tutorialItemMessageConfig;
}
