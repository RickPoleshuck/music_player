import 'dart:io';

import 'package:sqlite3/sqlite3.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static final DatabaseService _singleton = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _singleton;
  }

  DatabaseService._internal() {}

  Future<Database> get db async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/prefs.db';

    final db = sqlite3.open(path);
    db.execute('''
      create table if not exists preference (
        key text primary key,
        value text
      ) without rowid
    ''');
    db.execute('''
      create table if not exists music (
        path text unique,
        last_played datetime default current_timestamp
      )
    ''');
    return db;
  }
}
