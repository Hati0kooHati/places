import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

class LocalDatabase {
  const LocalDatabase._();

  static sql.Database? _db;

  static Future<sql.Database> get db async {
    if (_db != null) {
      return _db!;
    }

    final dbPath = await sql.getDatabasesPath();

    _db = await sql.openDatabase(
      join(dbPath, "places.db"),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, imagePath TEXT, longitude REAL, latitude REAL, address TEXT)",
        );
      },
      version: 1,
    );
    return _db!;
  }
}
