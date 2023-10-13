import 'package:flutter/material.dart';
import 'package:music_player/src/services/preference_service.dart';

class SettingsService {
  static const musicFolderKey = 'music_folder';
  Future<ThemeMode> themeMode() async => ThemeMode.system;
  Future<void> updateThemeMode(ThemeMode theme) async {

  }
  Future<void> putMusicFolder(String musicFolder) async {
    PreferenceService().put(musicFolderKey, musicFolder);
  }

  Future<String?> getMusicFolder() async {
    return PreferenceService().get(musicFolderKey);
  }
}
