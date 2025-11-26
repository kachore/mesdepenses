import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/depense.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('depenses.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE depenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titre TEXT NOT NULL,
        montant REAL NOT NULL,
        date TEXT NOT NULL,
        categorie TEXT NOT NULL
      )
    ''');
  }

  Future<int> create(Depense depense) async {
    final db = await database;
    return await db.insert('depenses', depense.toMap());
  }

  Future<List<Depense>> readAll() async {
    final db = await database;
    final result = await db.query('depenses', orderBy: 'date DESC');
    return result.map((map) => Depense.fromMap(map)).toList();
  }

  Future<int> update(Depense depense) async {
    final db = await database;
    return await db.update(
      'depenses',
      depense.toMap(),
      where: 'id = ?',
      whereArgs: [depense.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      'depenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}