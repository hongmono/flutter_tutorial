import 'package:flutter/material.dart';

import 'tutorial_view.dart';
import 'messages/message.dart';

class Tutorial {
  final BuildContext context;

  /// Message Box padding
  ///
  /// Default: `const EdgeInsets.symmetric(horizontal: 16, vertical: 8)`
  EdgeInsetsGeometry? messagePadding;

  /// Message Box decoration
  ///
  /// Default: `BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))`
  BoxDecoration? messageDecoration;

  /// Message Box text style
  TextStyle? messageStyle;

  /// Triangle color
  ///
  /// Default: `Colors.white`
  Color? triangleColor;

  /// Triangle size
  ///
  /// Default: `const Size(10, 10)`
  Size? triangleSize;

  /// Message Box Padding
  ///
  /// Default: `const EdgeInsets.all(24)`
  EdgeInsetsGeometry? padding;

  /// Axis
  ///
  /// Default: `Axis.vertical`
  Axis? axis;

  Tutorial.of(this.context);

  Future<void> start(List<List<Message>> messages) async {
    await Navigator.push(
      context,
      HeroDialogRoute(
        builder: (context) {
          return TutorialView(
            messages: messages,
            messagePadding: messagePadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            messageDecoration: messageDecoration ?? BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            messageStyle: messageStyle ?? const TextStyle(color: Colors.black, fontSize: 16),
            triangleColor: triangleColor ?? Colors.white,
            triangleSize: triangleSize ?? const Size(10, 10),
            padding: padding ?? const EdgeInsets.all(24),
            axis: axis ?? Axis.vertical,
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
