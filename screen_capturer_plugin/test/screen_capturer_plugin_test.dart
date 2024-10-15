import 'package:flutter_test/flutter_test.dart';
import 'package:screen_capturer_plugin/screen_capturer_plugin.dart';
import 'package:screen_capturer_plugin/screen_capturer_plugin_platform_interface.dart';
import 'package:screen_capturer_plugin/screen_capturer_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockScreenCapturerPluginPlatform
    with MockPlatformInterfaceMixin
    implements ScreenCapturerPluginPlatform {

  @override
  Future<List<String>?> makeScreenshot() => Future.value(['42']);

  @override
  Future<bool?> isAccessAllowed() => Future.value(false);

  @override
  Future<void> requestAccess() async {}
}

void main() {
  final ScreenCapturerPluginPlatform initialPlatform = ScreenCapturerPluginPlatform.instance;

  test('$MethodChannelScreenCapturerPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelScreenCapturerPlugin>());
  });

  test('makeScreenshot', () async {
    ScreenCapturerPlugin screenCapturerPlugin = ScreenCapturerPlugin();
    MockScreenCapturerPluginPlatform fakePlatform = MockScreenCapturerPluginPlatform();
    ScreenCapturerPluginPlatform.instance = fakePlatform;

    expect((await screenCapturerPlugin.makeScreenshot())!.first, '42');
  });

  test('isAccessAllowed', () async {
    ScreenCapturerPlugin screenCapturerPlugin = ScreenCapturerPlugin();
    MockScreenCapturerPluginPlatform fakePlatform = MockScreenCapturerPluginPlatform();
    ScreenCapturerPluginPlatform.instance = fakePlatform;

    expect(await screenCapturerPlugin.isAccessAllowed(), false);
  });
}