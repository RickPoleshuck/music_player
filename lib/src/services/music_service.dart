import 'dart:io';

import 'package:music_player/src/services/database_service.dart';
import 'package:sqlite3/sqlite3.dart';

class MusicService {
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

  Future<String?> getRandom() async {
    final Database db = await DatabaseService().db;
    final rs = db.select('''
      select path from music order by random() limit 1
    ''');
    if (rs.isEmpty) return null;
    return rs.rows[0][0].toString();
  }
}
