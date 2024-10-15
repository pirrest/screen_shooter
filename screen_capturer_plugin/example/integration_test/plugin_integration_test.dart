// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://docs.flutter.dev/cookbook/testing/integration/introduction


import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:screen_capturer_plugin/screen_capturer_plugin.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('makeScreenshot test', (WidgetTester tester) async {
    final ScreenCapturerPlugin plugin = ScreenCapturerPlugin();
    final List<String>? shots = await plugin.makeScreenshot();
    expect(shots?.isNotEmpty, true);
  });

  testWidgets('isAccessAllowed test', (WidgetTester tester) async {
    final ScreenCapturerPlugin plugin = ScreenCapturerPlugin();
    final bool res = await plugin.isAccessAllowed();
    expect(res, false);
  });
}