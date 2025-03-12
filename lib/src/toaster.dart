import 'package:flutter/material.dart';
import 'toast.dart';

class Toaster extends StatefulWidget {
  final ToastPosition position;
  final double offset;

  const Toaster({
    super.key,
    this.position = ToastPosition.top,
    this.offset = 32.0,
  });

  @override
  State<Toaster> createState() => _ToasterState();
}

class _ToasterState extends State<Toaster> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ToastManager(),
      builder: (context, child) {
        return Stack(
          children: ToastManager().toasts.map((toast) => toast.widget).toList(),
        );
      },
    );
  }
}
