import 'package:flutter/material.dart';

import 'settings_service.dart';

class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;
  late ThemeMode _themeMode;
  late String _musicFolder;
  ThemeMode get themeMode => _themeMode;
  String get musicFolder => _musicFolder;

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _musicFolder = await _settingsService.getMusicFolder() ?? 'Music';
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;

    notifyListeners();

    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> updateMusicFolder(String? musicFolder) async {
    if (musicFolder == null) return;

    if (musicFolder == _musicFolder) return;

    _musicFolder = musicFolder;

    notifyListeners();

    await _settingsService.putMusicFolder(musicFolder);
  }
}
