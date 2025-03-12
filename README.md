# 🍞 Sonner Flutter

[![WIP](https://img.shields.io/badge/Status-WIP-orange)](https://img.shields.io/badge/Status-WIP-orange)

A sleek toast notification package for Flutter, inspired by the popular [Sonner](https://sonner.emilkowal.ski/) library from React.

<!-- ![Sonner Flutter Demo](https://github.com/yourusername/sonner_flutter/raw/main/assets/demo.gif) -->

## ✨ Features

- 🎯 **Simple API** - Easy to use with minimal setup
- 🌈 **Multiple toast types** - Success, error, info, warning, and normal variants
- 🔄 **Promise toasts** - Show loading, success, and error states for async operations
- 🎨 **Customizable** - Easily adjust position, duration, and appearance
- ⚡ **Lightweight** - Minimal impact on your app's performance
- 🖱️ **Interactive** - Support for action buttons within toasts
- 🔔 **Descriptive** - Add detailed descriptions to your toast messages

## 📦 Installation

```yaml
dependencies:
  sonner_flutter: ^1.0.0
```

## 🚀 Quick Start

1. Add the `Toaster` widget to your app:

```dart
import 'package:flutter/material.dart';
import 'package:sonner_flutter/sonner_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            const Toaster(), // Add Toaster widget here
          ],
        );
      },
    );
  }
}
```

2. Show toasts from anywhere in your app:

```dart
ElevatedButton(
  onPressed: () => Toast.success(context, 'Event has been created'),
  child: const Text('Show Success Toast'),
),
```

## 📚 API Reference

### Toast Types

```dart
// Basic toast
Toast.call(context, 'Hello World');

// Message toast (same as basic)
Toast.message(context, 'Hello World');

// Success toast
Toast.success(context, 'Operation completed successfully');

// Error toast
Toast.error(context, 'An error occurred');

// Warning toast
Toast.warning(context, 'Proceed with caution');

// Info toast
Toast.info(context, 'Just so you know...');

// Promise toast
Toast.promise(
  context,
  () => Future.delayed(
    const Duration(seconds: 2),
    () => {'status': 'completed'}
  ),
  loading: 'Processing request...',
  success: (data) => 'Request ${data['status']}',
  error: 'Request failed',
);
```

### Additional Options

All toast methods support these optional parameters:

```dart
Toast.success(
  context,
  'Event has been created',
  description: 'Monday, January 3rd at 6:00pm', // Add additional details
  action: ToastAction(                          // Add an interactive button
    label: 'Undo',
    onClick: () => print('Undo clicked'),
  ),
);
```

### Promise Toasts

Handle loading, success, and error states for async operations:

```dart
Future<Map<String, String>> fetchData() =>
  Future.delayed(const Duration(seconds: 2), () => {'name': 'Sonner'});

Toast.promise(
  context,
  fetchData,                                    // Your async function
  loading: 'Loading data...',                   // Shown during load
  success: (data) => 'Welcome, ${data['name']}', // Shown on success
  error: 'Failed to load data',                 // Shown on error
);
```

### Custom Toasts

Create completely custom toast content:

```dart
Toast.custom(
  context,
  Row(
    children: [
      Icon(Icons.celebration, color: Colors.white),
      SizedBox(width: 8),
      Text('Custom toast with icon', style: TextStyle(color: Colors.white)),
    ],
  ),
);
```

### Toaster Configuration

Customize the global toast container:

```dart
const Toaster(
  position: ToastPosition.top,  // ToastPosition.top or ToastPosition.bottom
  offset: 32.0,                 // Distance from the edge of the screen
),
```

## 🖼️ Examples

### Basic Example

```dart
ElevatedButton(
  onPressed: () => Toast.message(
    context,
    'Message sent',
    description: 'Your message has been delivered',
  ),
  child: const Text('Send Message'),
)
```

### Interactive Toast Example

```dart
Toast.warning(
  context,
  'You are about to delete this item',
  action: ToastAction(
    label: 'Cancel',
    onClick: () {
      // Handle the action
      print('Deletion cancelled');
    },
  ),
);
```

### Async Operation Example

```dart
ElevatedButton(
  onPressed: () {
    Toast.promise(
      context,
      () => submitForm(),  // Returns a Future
      loading: 'Submitting form...',
      success: (_) => 'Form submitted successfully',
      error: 'Failed to submit form',
    );
  },
  child: const Text('Submit Form'),
)
```

## 🤝 Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request if you have a way to improve this package.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
