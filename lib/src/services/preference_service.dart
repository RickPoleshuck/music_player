import 'package:music_player/src/services/database_service.dart';
import 'package:sqlite3/sqlite3.dart';

class PreferenceService {
  final Future<Database>_db = DatabaseService().db;
  Future<void> put(final String key, final String value) async {
    final db = await _db;
    db.execute('''
      insert into preference (key, value) values (?,?)
      on conflict(key) do update set value=?;
    ''', [key, value, value]);
  }

  Future<String?> get(final String key) async {
    final db = await _db;
    final rs = db.select('''
      select value from preference where key = ?
    ''', [key]);
    if (rs.isEmpty) return null;
    return rs.rows[0][0].toString();
  }
}