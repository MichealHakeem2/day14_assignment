import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SqfliteHelper {
  static final SqfliteHelper instance = SqfliteHelper._init();
  static Database? _database;

  SqfliteHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('shopping_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (kIsWeb) {
      return await databaseFactoryFfiWebNoWebWorker.openDatabase(
        inMemoryDatabasePath,
        options: OpenDatabaseOptions(
          version: 2,
          onCreate: _createDB,
          onOpen: _onOpenDB,
          onUpgrade: (db, oldVersion, newVersion) async {
            await _createDB(db, newVersion);
          },
        ),
      );
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onOpen: _onOpenDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        await _createDB(db, newVersion);
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        phone TEXT,
        token TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS products (
        id INTEGER PRIMARY KEY,
        title TEXT,
        price REAL,
        image TEXT,
        description TEXT,
        category TEXT,
        brand TEXT,
        rating REAL,
        stock INTEGER,
        isFavorite INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE,
        slug TEXT,
        image TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER UNIQUE,
        title TEXT,
        price REAL,
        image TEXT,
        quantity INTEGER DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER UNIQUE,
        title TEXT,
        price REAL,
        image TEXT,
        category TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_profile (
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        phone TEXT,
        address TEXT,
        image TEXT
      )
    ''');
  }

  Future<void> _onOpenDB(Database db) async {
    await _createDB(db, 2);
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
    _database = null;
  }
}
