import 'package:tutorial/src/tutorial.dart';

abstract class Message {
  const Message({
    this.message,
    this.tooltipConfig,
  });

  final String? message;

  final TooltipConfig? tooltipConfig;
}
