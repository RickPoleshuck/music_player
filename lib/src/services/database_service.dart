import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static final DatabaseService _singleton = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _singleton;
  }

  DatabaseService._internal() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/music.db';

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
        last_played datetime
      )
    ''');
    return db;
  }
}
