import 'package:flutter/material.dart';
import 'package:screen_capturer_plugin/screen_capturer_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _screenCapturerPlugin = ScreenCapturerPlugin();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: FilledButton(onPressed: () async {
            final shots = await _screenCapturerPlugin.makeScreenshot();
            debugPrint(shots?.first);
          }, child: const Text("Make screenshot")),
        ),
      ),
    );
  }
}