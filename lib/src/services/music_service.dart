import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/src/services/database_service.dart';
import 'package:sqlite3/sqlite3.dart';

class MusicService {
  static final MusicService _singleton = MusicService._internal();
  late AudioPlayer player;
  factory MusicService() {
    return _singleton;
  }

  MusicService._internal(){
    List<AudioPlayer> audioPlayers = List.generate(
      1,
          (_) => AudioPlayer()..setReleaseMode(ReleaseMode.stop),
    );
    player = audioPlayers[0];
  }

  Future<void> loadMusic(final String rootFolder) async {
    final Database db = await DatabaseService().db;
    Directory(rootFolder).list(recursive: true).handleError((e) {}).where((e) {
      return e is! Directory && e.path.toLowerCase().endsWith(".mp3");
    }).forEach((e) {
      db.execute(
          'insert into music (path) values (?) on conflict(path) do update set path=?',
          [e.path, e.path]);
      print(e.path);
    });
  }

  Future<bool> play(final String mp3) async {
    final completer = Completer<bool>();
    final String url = 'file://$mp3';
    await player.play(UrlSource(url));
    player.onPlayerStateChanged.listen((e) {
      switch(e) {
        case PlayerState.stopped:
        case PlayerState.paused:
        case PlayerState.disposed:
        case PlayerState.completed:
          completer.complete(true);
          break;
        case PlayerState.playing:
          break;
      }
    });
    return completer.future;
  }


  Future<String?> getRandom() async {
    final Database db = await DatabaseService().db;
    final rs = db.select('''
      select path from music order by random() limit 1
    ''');
    if (rs.isEmpty) return null;
    return rs.rows[0][0].toString();
  }
}
