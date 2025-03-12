import 'package:flutter/material.dart';
import 'dart:async';

class ToastManager extends ChangeNotifier {
  // Singleton pattern to ensure a single instance
  static final ToastManager _instance = ToastManager._internal();
  factory ToastManager() => _instance;
  ToastManager._internal();

  // List to hold toast entries
  final List<_ToastEntry> toasts = [];

  // Add a toast and notify listeners
  void addToast(_ToastEntry toast) {
    toasts.add(toast);
    notifyListeners(); // Trigger rebuild when a toast is added
    Future.delayed(toast.duration, () => removeToast(toast));
  }

  // Remove a toast and notify listeners
  void removeToast(_ToastEntry toast) {
    toasts.remove(toast);
    notifyListeners(); // Trigger rebuild when a toast is removed
  }

  // Clear all toasts and notify listeners
  void clear() {
    toasts.clear();
    notifyListeners(); // Trigger rebuild when toasts are cleared
  }
}

// A simple class to represent a toast entry (assuming this exists in your code)
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
    late _ToastEntry toastEntry; // Declare toastEntry with 'late'

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
        onDismiss: () =>
            ToastManager().removeToast(toastEntry), // Now safe to reference
      ),
    );

    toastEntry = _ToastEntry(toastWidget,
        duration: duration); // Initialize toastEntry with named parameter
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
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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
      // ignore: unreachable_switch_default
      default:
        return Colors.grey[800]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
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
    );
  }
}
