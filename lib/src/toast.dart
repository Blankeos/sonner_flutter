import 'package:flutter/material.dart';
import 'dart:async';

class ToastManager extends ChangeNotifier {
  static final ToastManager _instance = ToastManager._internal();
  factory ToastManager() => _instance;
  ToastManager._internal();

  final List<_ToastEntry> toasts = [];

  void addToast(_ToastEntry toast) {
    toasts.add(toast);
    notifyListeners();
    Future.delayed(toast.duration, () => removeToast(toast));
  }

  void removeToast(_ToastEntry toast) {
    if (toasts.contains(toast)) {
      toasts.remove(toast);
      notifyListeners();
    }
  }

  void clear() {
    toasts.clear();
    notifyListeners();
  }
}

class _ToastEntry {
  final Widget widget;
  final Duration duration;

  _ToastEntry(this.widget, {this.duration = const Duration(seconds: 3)});
}

class Toast {
  static void _show({
    required BuildContext context,
    required Widget content,
    ToastType type = ToastType.normal,
    String? description,
    Duration duration = const Duration(seconds: 3),
    ToastPosition position = ToastPosition.top,
    double offset = 32.0,
    ToastAction? action,
  }) {
    late _ToastEntry toastEntry;

    final toastWidget = Positioned(
      top: position == ToastPosition.top ? offset : null,
      bottom: position == ToastPosition.bottom ? offset : null,
      left: 16,
      right: 16,
      child: _ToastWidget(
        content: content,
        type: type,
        description: description,
        action: action,
        onDismiss: () => ToastManager().removeToast(toastEntry),
      ),
    );

    toastEntry = _ToastEntry(toastWidget, duration: duration);
    ToastManager().addToast(toastEntry);
  }

  static void call(
    BuildContext context,
    String message, {
    String? description,
    ToastAction? action,
  }) {
    _show(
      context: context,
      content: Text(message),
      description: description,
      action: action,
    );
  }

  static void message(
    BuildContext context,
    String message, {
    String? description,
    ToastAction? action,
  }) {
    _show(
      context: context,
      content: Text(message),
      description: description,
      action: action,
    );
  }

  static void success(
    BuildContext context,
    String message, {
    String? description,
    ToastAction? action,
  }) {
    _show(
      context: context,
      content: Text(message),
      type: ToastType.success,
      description: description,
      action: action,
    );
  }

  static void info(
    BuildContext context,
    String message, {
    String? description,
    ToastAction? action,
  }) {
    _show(
      context: context,
      content: Text(message),
      type: ToastType.info,
      description: description,
      action: action,
    );
  }

  static void warning(
    BuildContext context,
    String message, {
    String? description,
    ToastAction? action,
  }) {
    _show(
      context: context,
      content: Text(message),
      type: ToastType.warning,
      description: description,
      action: action,
    );
  }

  static void error(
    BuildContext context,
    String message, {
    String? description,
    ToastAction? action,
  }) {
    _show(
      context: context,
      content: Text(message),
      type: ToastType.error,
      description: description,
      action: action,
    );
  }

  static void promise<T>(
    BuildContext context,
    Future<T> Function() promise, {
    required String loading,
    required dynamic Function(T) success,
    required String error,
  }) {
    _show(context: context, content: Text(loading));

    promise().then((value) {
      ToastManager().clear();
      final successContent = success(value);
      _show(
        context: context,
        content:
            successContent is String ? Text(successContent) : successContent,
        type: ToastType.success,
      );
    }).catchError((e) {
      ToastManager().clear();
      _show(context: context, content: Text(error), type: ToastType.error);
    });
  }

  static void custom(BuildContext context, Widget content) {
    _show(context: context, content: content);
  }
}

class ToastAction {
  final String label;
  final VoidCallback onClick;

  ToastAction({required this.label, required this.onClick});
}

enum ToastType {
  normal,
  success,
  error,
  warning,
  info,
}

enum ToastPosition {
  top,
  bottom,
}

class _ToastWidget extends StatefulWidget {
  final Widget content;
  final ToastType type;
  final String? description;
  final ToastAction? action;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.content,
    required this.type,
    this.description,
    this.action,
    required this.onDismiss,
  });

  @override
  _ToastWidgetState createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _dragController;
  late Animation<double> _dragAnimation;
  double _dragOffset = 0.0;
  static const double _dismissThreshold = 30.0;

  @override
  void initState() {
    super.initState();
    // Fade animation for entry/exit
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _fadeController.forward();

    // Drag animation for smooth return
    _dragController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _dragAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _dragController, curve: Curves.easeOut),
    )..addListener(() {
        setState(() {
          _dragOffset = _dragAnimation.value;
        });
      });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _dragController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case ToastType.success:
        return Colors.green[700]!;
      case ToastType.error:
        return Colors.red[700]!;
      case ToastType.warning:
        return Colors.orange[700]!;
      case ToastType.info:
        return Colors.blue[700]!;
      case ToastType.normal:
      default:
        return Colors.grey[800]!;
    }
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset =
          (_dragOffset + details.delta.dy).clamp(0.0, double.infinity);
    });
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    if (_dragOffset >= _dismissThreshold) {
      // Dismiss if dragged beyond threshold
      _fadeController.reverse().then((_) => widget.onDismiss());
    } else {
      // Animate back to original position
      _dragAnimation = Tween<double>(begin: _dragOffset, end: 0).animate(
        CurvedAnimation(parent: _dragController, curve: Curves.easeOut),
      );
      _dragController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Transform.translate(
        offset: Offset(0, _dragOffset),
        child: GestureDetector(
          onVerticalDragUpdate: _handleVerticalDragUpdate,
          onVerticalDragEnd: _handleVerticalDragEnd,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(child: widget.content),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: widget.onDismiss,
                      ),
                    ],
                  ),
                  if (widget.description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        widget.description!,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  if (widget.action != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextButton(
                        onPressed: widget.action!.onClick,
                        child: Text(
                          widget.action!.label,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
