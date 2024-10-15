import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'screen_capturer_plugin_platform_interface.dart';

/// An implementation of [ScreenCapturerPluginPlatform] that uses method channels.
class MethodChannelScreenCapturerPlugin extends ScreenCapturerPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('screen_capturer_plugin');

  @override
  Future<List<String>?> makeScreenshot() async {
    final res = await methodChannel.invokeMethod<List<Object?>>('makeScreenshot');
    if(res != null) {
      return List<String>.from(res);
    } else {
      return null;
    }
  }

  @override
  Future<bool?> isAccessAllowed() async {
    return await methodChannel.invokeMethod<bool>('isAccessAllowed');
  }

  @override
  Future<void> requestAccess() async {
    await methodChannel.invokeMethod('requestAccess');
  }
}