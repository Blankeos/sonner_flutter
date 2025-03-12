import 'package:flutter/material.dart';
import 'package:sonner_flutter/sonner_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            const Toaster(), // Add Toaster widget
          ],
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  Future<Map<String, String>> _promise() =>
      Future.delayed(const Duration(seconds: 2), () => {'name': 'Sonner'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Toast.call(context, 'My first toast'),
              child: const Text('Give me a toast'),
            ),
            ElevatedButton(
              onPressed: () => Toast.success(context, 'Event has been created'),
              child: const Text('Success toast'),
            ),
            ElevatedButton(
              onPressed: () => Toast.message(
                context,
                'Event has been created',
                description: 'Monday, January 3rd at 6:00pm',
              ),
              child: const Text('Message with description'),
            ),
            ElevatedButton(
              onPressed: () => Toast.error(
                context,
                'Event has not been created',
                action: ToastAction(
                  label: 'Undo',
                  onClick: () => print('Undo clicked'),
                ),
              ),
              child: const Text('Error with action'),
            ),
            ElevatedButton(
              onPressed: () => Toast.promise(
                context,
                _promise,
                loading: 'Loading...',
                success: (data) => '${data['name']} toast has been added',
                error: 'Error',
              ),
              child: const Text('Promise toast'),
            ),
            ElevatedButton(
              onPressed: () => Toast.custom(
                context,
                const Row(
                  children: [
                    Icon(Icons.star, color: Colors.white),
                    SizedBox(width: 8),
                    Text('A custom toast',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              child: const Text('Custom toast'),
            ),
          ],
        ),
      ),
    );
  }
}
