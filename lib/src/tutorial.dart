import 'package:flutter/material.dart';

import 'tutorial_view.dart';
import 'messages/message.dart';

class Tutorial {
  final BuildContext context;

  /// Message Box padding
  final EdgeInsetsGeometry? messagePadding;

  /// Message Box decoration
  final BoxDecoration? messageDecoration;

  /// Message Box text style
  final TextStyle? messageStyle;

  /// Triangle color
  final Color? triangleColor;

  const Tutorial.of(
    this.context, {
    this.messagePadding,
    this.messageDecoration,
    this.messageStyle,
    this.triangleColor,
  });

  void start(List<List<Message>> messages) {
    Navigator.push(
      context,
      HeroDialogRoute(
        builder: (context) {
          return TutorialView(
            messages: messages,
            messagePadding: messagePadding,
            messageDecoration: messageDecoration,
            messageStyle: messageStyle,
            triangleColor: triangleColor,
          );
        },
      ),
    );
  }
}

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({
    required this.builder,
    this.color = Colors.black54,
    this.duration = const Duration(milliseconds: 300),
  }) : super();

  final WidgetBuilder builder;
  final Duration duration;
  final Color color;

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => color;

  @override
  String? get barrierLabel => 'HeroDialogRoute';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;
}
