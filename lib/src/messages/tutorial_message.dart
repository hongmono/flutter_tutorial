import 'package:flutter/material.dart';

import 'message.dart';

class TutorialMessage extends Message {
  const TutorialMessage({
    super.message,
    required this.child,
  });

  final Widget child;
}
