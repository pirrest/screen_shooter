import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'screen_capturer_plugin_method_channel.dart';

abstract class ScreenCapturerPluginPlatform extends PlatformInterface {
  /// Constructs a ScreenCapturerPluginPlatform.
  ScreenCapturerPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static ScreenCapturerPluginPlatform _instance = MethodChannelScreenCapturerPlugin();

  /// The default instance of [ScreenCapturerPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelScreenCapturerPlugin].
  static ScreenCapturerPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ScreenCapturerPluginPlatform] when
  /// they register themselves.
  static set instance(ScreenCapturerPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<String>?> makeScreenshot() {
    throw UnimplementedError('makeScreenshot() has not been implemented.');
  }

  Future<bool?> isAccessAllowed() {
    throw UnimplementedError('isAccessAllowed() has not been implemented.');
  }

  Future<void> requestAccess() {
    throw UnimplementedError('requestAccess() has not been implemented.');
  }
}