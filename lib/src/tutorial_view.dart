import 'package:flutter/material.dart';
import 'package:tutorial/src/tooltip_widget.dart';

import 'messages/tutorial_message.dart';
import 'messages/message.dart';
import 'messages/tutorial_item_message.dart';
import 'tutorial.dart';
import 'tutorial_item.dart';

class TutorialView extends StatefulWidget {
  const TutorialView({
    super.key,
    required this.messages,
    required this.messageConfig,
    required this.itemMessageConfig,
    required this.tooltipConfig,
  });

  /// Messages
  final List<List<Message>> messages;

  final TutorialMessageConfig messageConfig;

  final TutorialItemMessageConfig itemMessageConfig;

  final TooltipConfig tooltipConfig;

  @override
  State<TutorialView> createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> {
  List<List<Message>> messages = [];
  final TooltipController controller = TooltipController();

  @override
  void initState() {
    messages = widget.messages;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<Message> message = messages.removeAt(0);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 50));
      controller.show();
    });

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        controller.dismiss();
        if (mounted) {
          if (messages.isEmpty) {
            Navigator.pop(context);
          } else {
            setState(() {});
          }
        }
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [...message.map(buildTutorialItem)],
          ),
        ),
      ),
    );
  }

  Widget buildTutorialItem(Message message) {
    Widget? child;
    double? top;
    double? bottom;
    double? left;
    double? right;

    if (message is TutorialMessage) {
      child = message.tutorialMessageConfig?.child ?? widget.messageConfig.child ?? const CircleAvatar(child: FlutterLogo());
      top = message.tutorialMessageConfig?.top ?? widget.messageConfig.top;
      bottom = message.tutorialMessageConfig?.bottom ?? widget.messageConfig.bottom;
      left = message.tutorialMessageConfig?.left ?? widget.messageConfig.left;
      right = message.tutorialMessageConfig?.right ?? widget.messageConfig.right;
    } else if (message is TutorialItemMessage) {
      if (message.targetKey.currentContext == null) {
        Exception('Target key is null');
        return const SizedBox.shrink();
      }

      if (message.targetKey.currentWidget is TutorialItem == false) {
        Exception('Target Widget is not a Tutorial');
        return const SizedBox.shrink();
      }

      final RenderBox renderBox = message.targetKey.currentContext!.findRenderObject() as RenderBox;
      final Offset offset = renderBox.localToGlobal(Offset.zero);

      top = offset.dy;
      left = offset.dx;

      final TutorialItem target = message.targetKey.currentWidget! as TutorialItem;

      if ((message.tutorialItemMessageConfig?.foregroundColor ?? widget.itemMessageConfig.foregroundColor) != null) {
        child = ColorFiltered(
          colorFilter: ColorFilter.mode(message.tutorialItemMessageConfig?.foregroundColor ?? widget.itemMessageConfig.foregroundColor!, BlendMode.srcIn),
          child: target.child,
        );
      } else {
        child = target.child;
      }
    }

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: TooltipWidget(
        key: UniqueKey(),
        controller: controller,
        targetPadding: 4,
        messageDecoration: message.tooltipConfig?.messageDecoration ?? widget.tooltipConfig.messageDecoration,
        messagePadding: message.tooltipConfig?.messagePadding ?? widget.tooltipConfig.messagePadding,
        messageStyle: message.tooltipConfig?.messageStyle ?? widget.tooltipConfig.messageStyle,
        triangleColor: message.tooltipConfig?.triangleColor ?? widget.tooltipConfig.triangleColor,
        triangleSize: message.tooltipConfig?.triangleSize ?? widget.tooltipConfig.triangleSize,
        padding: message.tooltipConfig?.padding ?? widget.tooltipConfig.padding,
        axis: message.tooltipConfig?.axis ?? widget.tooltipConfig.axis,
        message: message.message,
        alignment: message.tooltipConfig?.alignment,
        child: IgnorePointer(ignoring: true, child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
