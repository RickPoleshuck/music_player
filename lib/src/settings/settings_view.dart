import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      final folder =
                          await FilePicker.platform.getDirectoryPath();
                      if (folder == null) return;
                      final Directory root = Directory(folder!);
                      root.list(recursive: true).handleError((e) {}).where((e) {
                        return e is! Directory &&
                            e.path.toLowerCase().endsWith(".mp3");
                      }).forEach((element) {
                        print(element.toString());
                      });
                      controller.updateMusicFolder(folder);
                    },
                    child: const Text('Select Folder')),
                Text(controller.musicFolder),
              ],
            ),
            DropdownButton<ThemeMode>(
              // Read the selected themeMode from the controller
              value: controller.themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: controller.updateThemeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
