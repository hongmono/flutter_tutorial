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
    this.triangleColor,
    this.targetPadding,
    this.onShow,
    this.onDismiss,
    this.controller,
    this.messagePadding,
    this.messageDecoration,
    this.messageStyle,
  });

  /// Message
  final String? message;

  /// Target Widget
  final Widget child;

  /// Triangle color
  final Color? triangleColor;

  /// Gap between target and tooltip
  final double? targetPadding;

  /// Show callback
  final VoidCallback? onShow;

  /// Dismiss callback
  final VoidCallback? onDismiss;

  /// Tooltip Controller
  final TooltipController? controller;

  /// Message Box padding
  final EdgeInsetsGeometry? messagePadding;

  /// Message Box decoration
  final BoxDecoration? messageDecoration;

  /// Message Box text style
  final TextStyle? messageStyle;

  @override
  State<TooltipWidget> createState() => _TooltipWidgetState();
}

class _TooltipWidgetState extends State<TooltipWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  final key = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    widget.controller?.addListener(() {
      if (widget.controller?.isShow == true) {
        show();
      } else {
        dismiss();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _animationController.dispose();

    super.dispose();
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
              child: FadeTransition(
                opacity: _animation,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: builder.tooltip,
                ),
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

  void dismiss() async {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      widget.onDismiss?.call();
    }
  }

  ({Alignment targetAnchor, Alignment followerAnchor, Widget tooltip}) makeAlignment({
    EdgeInsetsGeometry? messagePadding,
    BoxDecoration? messageDecoration,
    TextStyle? messageStyle,
    Color? triangleColor,
    String? message = '',
  }) {
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;

    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    final centerPosition = Offset(position.dx + size.width / 2, position.dy + size.height / 2);

    Alignment targetAnchor;
    Alignment followerAnchor;
    Widget tooltip;

    final Widget messageBox = Material(
      type: MaterialType.transparency,
      child: Container(
        padding: messagePadding,
        decoration: messageDecoration,
        child: Text(message!, style: messageStyle),
      ),
    );

    if (centerPosition.dy < MediaQuery.of(context).size.height / 2) {
      if (centerPosition.dx < MediaQuery.of(context).size.width / 3) {
        followerAnchor = Alignment.topLeft;
        targetAnchor = Alignment.bottomLeft;
        tooltip = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: widget.targetPadding ?? 0),
            Padding(
              padding: EdgeInsets.only(left: size.width / 2 - 5),
              child: UpperTriangleWidget(
                backgroundColor: widget.triangleColor ?? Colors.white,
              ),
            ),
            messageBox,
          ],
        );
      } else if (centerPosition.dx > MediaQuery.of(context).size.width / 3 * 2) {
        followerAnchor = Alignment.topRight;
        targetAnchor = Alignment.bottomRight;
        tooltip = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: widget.targetPadding ?? 0),
            Padding(
              padding: EdgeInsets.only(right: size.width / 2 - 5),
              child: UpperTriangleWidget(
                backgroundColor: widget.triangleColor ?? Colors.white,
              ),
            ),
            messageBox,
          ],
        );
      } else {
        followerAnchor = Alignment.topCenter;
        targetAnchor = Alignment.bottomCenter;
        tooltip = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: widget.targetPadding ?? 0),
            UpperTriangleWidget(
              backgroundColor: widget.triangleColor ?? Colors.white,
            ),
            messageBox,
          ],
        );
      }
    } else {
      if (centerPosition.dx < MediaQuery.of(context).size.width / 3) {
        targetAnchor = Alignment.topLeft;
        followerAnchor = Alignment.bottomLeft;

        tooltip = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            messageBox,
            Padding(
              padding: EdgeInsets.only(left: size.width / 2 - 5),
              child: DownTriangleWidget(
                backgroundColor: widget.triangleColor ?? Colors.white,
              ),
            ),
            SizedBox(height: widget.targetPadding ?? 0),
          ],
        );
      } else if (centerPosition.dx > MediaQuery.of(context).size.width / 3 * 2) {
        followerAnchor = Alignment.bottomRight;
        targetAnchor = Alignment.topRight;

        tooltip = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            messageBox,
            Padding(
              padding: EdgeInsets.only(right: size.width / 2 - 5),
              child: DownTriangleWidget(
                backgroundColor: widget.triangleColor ?? Colors.white,
              ),
            ),
            SizedBox(height: widget.targetPadding ?? 0),
          ],
        );
      } else {
        followerAnchor = Alignment.bottomCenter;
        targetAnchor = Alignment.topCenter;

        tooltip = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            messageBox,
            DownTriangleWidget(
              backgroundColor: widget.triangleColor ?? Colors.white,
            ),
            SizedBox(height: widget.targetPadding ?? 0),
          ],
        );
      }
    }

    return (
      targetAnchor: targetAnchor,
      followerAnchor: followerAnchor,
      tooltip: tooltip,
    );
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
      size: const Size(7, 5), // 원하는 크기 지정
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
      size: const Size(7, 5), // 원하는 크기 지정
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
