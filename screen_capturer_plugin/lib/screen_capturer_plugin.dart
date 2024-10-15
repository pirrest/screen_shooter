import 'screen_capturer_plugin_platform_interface.dart';

class ScreenCapturerPlugin {
  Future<List<String>?> makeScreenshot() async {
    return await ScreenCapturerPluginPlatform.instance.makeScreenshot();
  }

  Future<bool> isAccessAllowed() async {
    return await ScreenCapturerPluginPlatform.instance.isAccessAllowed() ??
        false;
  }

  Future<void> requestAccess() async {
    await ScreenCapturerPluginPlatform.instance.requestAccess();
  }
}