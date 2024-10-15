import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_capturer_plugin/screen_capturer_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelScreenCapturerPlugin platform = MethodChannelScreenCapturerPlugin();
  const MethodChannel channel = MethodChannel('screen_capturer_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return ['42'];
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('makeScreenshot', () async {
    expect((await platform.makeScreenshot())!.first, '42');
  });

  test('isAccessAllowed', () async {
    expect(await platform.isAccessAllowed(), false);
  });
}