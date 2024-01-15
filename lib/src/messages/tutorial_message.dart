import 'package:tutorial/src/tutorial.dart';

import 'message.dart';

class TutorialMessage extends Message {
  const TutorialMessage({
    super.message,
    super.tooltipConfig,
    this.tutorialMessageConfig,
  });

  final TutorialMessageConfig? tutorialMessageConfig;
}
