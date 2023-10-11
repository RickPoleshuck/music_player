import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';

class SampleItemListView extends StatelessWidget {
  const SampleItemListView({
    super.key,
    this.items = const [SampleItem(1), SampleItem(2), SampleItem(3)],
  });

  static const routeName = '/';

  final List<SampleItem> items;

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
      body: ElevatedButton(onPressed: () async {
        final result = await FilePicker.platform.pickFiles(allowMultiple: false);

        if (result == null) return;
        print(result.files.first.path);
        List<AudioPlayer> audioPlayers = List.generate(
          1,
              (_) => AudioPlayer()..setReleaseMode(ReleaseMode.stop),
        );
        AudioPlayer player = audioPlayers[0];
        final String url = 'file://${result.files.first.path!}';
        print('url=$url');
        await player.play(UrlSource(url));
      }, child: const Text('File Browser')),
    );
  }
}
