import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screen_capturer_plugin/screen_capturer_plugin.dart';
import 'package:screen_shooter/preferences.dart';
import 'package:system_tray/system_tray.dart';

final preferences = Preferences();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screen shooter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AppWindow _appWindow = AppWindow();
  final SystemTray _systemTray = SystemTray();
  List<Image>? _images;
  final _plugin = ScreenCapturerPlugin();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (preferences.autoScreenShotsEnabled == true) {
      _enable(directorySelectionEnabled:false);
    } else {
      _disable();
    }
    _initSystemTray();
  }

  Future<void> _initSystemTray() async {
    await _systemTray.initSystemTray(iconPath: "assets/tray_icon.png");
    _systemTray.setToolTip("Shoots your screen periodically");

    _systemTray.registerSystemTrayEventHandler((eventName) {
      if (eventName == kSystemTrayEventClick ||
          eventName == kSystemTrayEventRightClick) {
        _appWindow.show();
      }
    });
  }

  Future<void> _takeAndSaveScreenshots() async {
    final shots = await _plugin.makeScreenshot();
    if (shots?.isNotEmpty == true) {
      final directory = preferences.directoryToSave;
      var index = 1;
      for (var shot in shots!) {
        final fileSuffix = index > 1 ? "-$index" : "";
        final file = File('$directory/screenshots$fileSuffix.txt');
        file.writeAsString(shot);
        index++;
      }
    } else {
      // TODO: show error to the user
    }
  }

  Future<void> _enable({bool directorySelectionEnabled = true}) async {
    if (_timer != null) return;
    String? selectedDirectory = directorySelectionEnabled
        ? await FilePicker.platform.getDirectoryPath()
        : preferences.directoryToSave;
    if (selectedDirectory != null) {
      _systemTray
          .setToolTip("Shoots your screen periodically (currently enabled)");
      preferences.setDirectoryToSave(selectedDirectory);
      preferences.setAutoScreenShotsEnabled(true);
      setState(() {
        _timer = Timer(Duration(minutes: 15), _takeAndSaveScreenshots);
      });
    }
  }

  Future<void> _disable() async {
    preferences.setAutoScreenShotsEnabled(false);
    preferences.setDirectoryToSave(null);
    _systemTray
        .setToolTip("Shoots your screen periodically (currently disabled)");
    setState(() {
      _timer?.cancel();
      _timer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Take screenshot every 15 mins"),
                SizedBox(width: 8),
                CupertinoSwitch(
                  value: _timer != null,
                  onChanged: (value) {
                    if (value) {
                      _enable();
                    } else {
                      _disable();
                    }
                  },
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () async {
              if (await _plugin.isAccessAllowed() == false) {
                await _plugin.requestAccess();
              }
              if (await _plugin.isAccessAllowed()) {
                final shots = await _plugin.makeScreenshot();
                setState(() {
                  if (shots?.isNotEmpty == true) {
                    _images = [
                      for (var shot in shots!) Image.memory(base64Decode(shot))
                    ];
                  }
                });
              }
            },
            child: Text("Take screenshot now"),
          ),
          if (_images != null)
            SizedBox(
                height: 400,
                child: _images != null
                    ? PageView(
                        controller: PageController(viewportFraction: 0.8),
                        children: _images!)
                    : null),
          FilledButton(
            onPressed: () {
              exit(0);
            },
            child: Text("Quit"),
          ),
        ],
      ),
    );
  }
}