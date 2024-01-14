import 'package:flutter/material.dart';

class TooltipController extends ChangeNotifier {
  bool _isShow = false;

  bool get isShow => _isShow;

  void show() {
    _isShow = true;
    notifyListeners();
  }

  void dismiss() {
    _isShow = false;
    notifyListeners();
  }
}

class TooltipWidget extends StatefulWidget {
  const TooltipWidget({
    super.key,
    required this.message,
    required this.child,
    required this.triangleColor,
    required this.triangleSize,
    required this.targetPadding,
    this.onShow,
    this.onDismiss,
    this.controller,
    required this.messagePadding,
    required this.messageDecoration,
    required this.messageStyle,
    required this.horizontalPadding,
  });

  /// Message
  final String? message;

  /// Target Widget
  final Widget child;

  /// Triangle color
  final Color triangleColor;

  /// Triangle size
  final Size triangleSize;

  /// Gap between target and tooltip
  final double? targetPadding;

  /// Show callback
  final VoidCallback? onShow;

  /// Dismiss callback
  final VoidCallback? onDismiss;

  /// Tooltip Controller
  final TooltipController? controller;

  /// Message Box padding
  final EdgeInsetsGeometry messagePadding;

  /// Message Box decoration
  final BoxDecoration messageDecoration;

  /// Message Box text style
  final TextStyle messageStyle;

  /// Message Box padding
  final double horizontalPadding;

  @override
  State<TooltipWidget> createState() => _TooltipWidgetState();
}

class _TooltipWidgetState extends State<TooltipWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  final key = GlobalKey();
  final messageBoxKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    widget.controller?.addListener(listener);

    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(listener);
    _overlayEntry?.remove();
    _animationController.dispose();

    super.dispose();
  }

  void listener() {
    if (widget.controller?.isShow == true) {
      show();
    } else {
      dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(key: key, child: widget.child),
    );
  }

  void show() {
    if (widget.message == null) return;

    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      return;
    }

    Alignment targetAnchor;
    Alignment followerAnchor;

    final builder = makeAlignment(
      messagePadding: widget.messagePadding,
      messageDecoration: widget.messageDecoration,
      messageStyle: widget.messageStyle,
      triangleColor: widget.triangleColor,
      message: widget.message,
    );

    if (builder == null) {
      return;
    }

    targetAnchor = builder.targetAnchor;
    followerAnchor = builder.followerAnchor;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            const SizedBox.expand(),
            CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: targetAnchor,
              followerAnchor: followerAnchor,
              offset: Offset(0, targetAnchor == Alignment.bottomCenter ? widget.targetPadding ?? 0 : -(widget.targetPadding ?? 0)),
              child: FadeTransition(
                opacity: _animation,
                child: SizedBox.fromSize(
                  size: widget.triangleSize,
                  child: targetAnchor == Alignment.bottomCenter ? const UpperTriangleWidget() : const DownTriangleWidget(),
                ),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: targetAnchor,
              followerAnchor: followerAnchor,
              offset: Offset(
                builder.dx,
                targetAnchor == Alignment.bottomCenter
                    ? widget.triangleSize.height + (widget.targetPadding ?? 0)
                    : -widget.triangleSize.height - (widget.targetPadding ?? 0),
              ),
              child: FadeTransition(
                opacity: _animation,
                child: builder.messageBox,
              ),
            ),
          ],
        );
      },
    );

    if (_overlayEntry != null) {
      Overlay.of(context).insert(_overlayEntry!);
      _animationController.forward();
      widget.onShow?.call();
    }
  }

  void dismiss() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      widget.onDismiss?.call();
    }
  }

  ({Alignment targetAnchor, Alignment followerAnchor, Widget messageBox, double dx})? makeAlignment({
    required EdgeInsetsGeometry messagePadding,
    required BoxDecoration messageDecoration,
    required TextStyle messageStyle,
    required Color triangleColor,
    String? message = '',
  }) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      Exception('RenderBox is null');
      return null;
    }

    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    final centerPosition = Offset(position.dx + size.width / 2, position.dy + size.height / 2);

    final Widget messageBox = Material(
      type: MaterialType.transparency,
      child: Container(
        key: messageBoxKey,
        padding: messagePadding,
        decoration: messageDecoration,
        child: RichText(text: TextSpan(text: message ?? '', style: messageStyle)),
      ),
    );

    Alignment targetAnchor;
    Alignment followerAnchor;

    if (centerPosition.dy > MediaQuery.of(context).size.height / 2) {
      targetAnchor = Alignment.topCenter;
      followerAnchor = Alignment.bottomCenter;
    } else {
      targetAnchor = Alignment.bottomCenter;
      followerAnchor = Alignment.topCenter;
    }

    final Size preferredSize = _textSize(message ?? '', messageStyle) + Offset(messagePadding.horizontal, messagePadding.vertical);
    final double overflowWidth = (preferredSize.width - size.width) / 2;
    double dx;

    if (overflowWidth < 0) {
      dx = 0;
    } else {
      final edgeFromLeft = position.dx;
      final edgeFromRight = MediaQuery.of(context).size.width - (position.dx + size.width);

      if (widget.horizontalPadding + edgeFromLeft - overflowWidth < 0) {
        dx = widget.horizontalPadding + overflowWidth - edgeFromLeft;
      } else if (widget.horizontalPadding + edgeFromRight - overflowWidth < 0) {
        dx = edgeFromRight - (overflowWidth + widget.horizontalPadding);
      } else {
        dx = 0;
      }
    }

    return (
      targetAnchor: targetAnchor,
      followerAnchor: followerAnchor,
      messageBox: messageBox,
      dx: dx,
    );
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}

class UpperTriangleWidget extends StatelessWidget {
  const UpperTriangleWidget({
    super.key,
    this.backgroundColor = Colors.white,
  });

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: UpperTrianglePainter(
        backgroundColor: backgroundColor,
      ),
    );
  }
}

class UpperTrianglePainter extends CustomPainter {
  const UpperTrianglePainter({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width, size.height); // 오른쪽 아래
    path.lineTo(size.width / 2, 0); // 꼭대기
    path.lineTo(0, size.height); // 왼쪽 아래
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DownTriangleWidget extends StatelessWidget {
  const DownTriangleWidget({
    super.key,
    this.backgroundColor = Colors.white,
  });

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DownTrianglePainter(
        backgroundColor: backgroundColor,
      ),
    );
  }
}

class DownTrianglePainter extends CustomPainter {
  const DownTrianglePainter({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.lineTo(size.width / 2, size.height); // 꼭대기
    path.lineTo(size.width, 0); // 오른쪽 위
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
