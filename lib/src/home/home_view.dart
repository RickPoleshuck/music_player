import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/src/services/music_service.dart';

import '../settings/settings_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
  });

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Files Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              List<AudioPlayer> audioPlayers = List.generate(
                1,
                (_) => AudioPlayer()..setReleaseMode(ReleaseMode.stop),
              );
              AudioPlayer player = audioPlayers[0];
              while (true) {
                final String? mp3 = await MusicService().getRandom();
                if (mp3 == null) break;
                await MusicService().play(mp3);
              }
            },
            child: const Text('Play')),
      ),
    );
  }
}
