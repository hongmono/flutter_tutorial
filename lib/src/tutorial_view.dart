import 'package:flutter/material.dart';
import 'package:tutorial/src/tooltip_widget.dart';

import 'messages/tutorial_message.dart';
import 'messages/message.dart';
import 'messages/tutorial_item_message.dart';
import 'tutorial_item.dart';

class TutorialView extends StatefulWidget {
  const TutorialView({
    super.key,
    required this.messages,
    required this.messagePadding,
    required this.messageDecoration,
    required this.messageStyle,
    required this.triangleColor,
    required this.triangleSize,
    required this.padding,
    required this.axis,
  });

  /// Messages
  final List<List<Message>> messages;

  /// Message Box padding
  final EdgeInsetsGeometry messagePadding;

  /// Message Box decoration
  final BoxDecoration messageDecoration;

  /// Message Box text style
  final TextStyle messageStyle;

  /// Triangle color
  final Color triangleColor;

  /// Triangle size
  final Size triangleSize;

  /// Message Box Padding
  final EdgeInsetsGeometry padding;

  /// Axis
  final Axis axis;

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
      Navigator.pop(context);
      return const SizedBox.shrink();
    }

    final List<Message> message = messages.removeAt(0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.show();
    });

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        controller.dismiss();
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [...message.map(buildTutorialItem)],
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
      child = message.child;
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

      if (message.foregroundColor != null) {
        child = ColorFiltered(
          colorFilter: ColorFilter.mode(message.foregroundColor!, BlendMode.srcIn),
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
        messageDecoration: widget.messageDecoration,
        messagePadding: widget.messagePadding,
        messageStyle: widget.messageStyle,
        triangleColor: widget.triangleColor,
        triangleSize: widget.triangleSize,
        message: message.message,
        padding: widget.padding,
        axis: widget.axis,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
