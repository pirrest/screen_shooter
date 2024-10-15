import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool? get autoScreenShotsEnabled => _prefs.getBool('autoScreenShotsEnabled');

  Future<void> setAutoScreenShotsEnabled(bool? value) async {
    if (value == null) {
      _prefs.remove('autoScreenShotsEnabled');
    } else {
      await _prefs.setBool('autoScreenShotsEnabled', value);
    }
  }

  String? get directoryToSave => _prefs.getString('directoryToSave');

  Future<void> setDirectoryToSave(String? value) async {
    if (value == null) {
      _prefs.remove('directoryToSave');
    } else {
      await _prefs.setString('directoryToSave', value);
    }
  }
}