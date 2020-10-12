import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Future<Database> getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'todo.db'),
      version: 1,
      onCreate: (db, version) async {
        return await db.execute(
          'CREATE TABLE todo_tasks(id TEXT PRIMARY KEY, title TEXT, description TEXT, date TEXT, time TEXT)',
        );
      },
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.getDatabase();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.getDatabase();
    return db.query(table);
  }

  static Future<void> delete(String table, String taskId) async {
    final db = await DBHelper.getDatabase();
    db.delete(
      table,
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }
}
