//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import screen_capturer_plugin
import shared_preferences_foundation
import system_tray

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  ScreenCapturerPlugin.register(with: registry.registrar(forPlugin: "ScreenCapturerPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SystemTrayPlugin.register(with: registry.registrar(forPlugin: "SystemTrayPlugin"))
}
