import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('myday.db');
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

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        type INTEGER NOT NULL,
        dueDate INTEGER,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        createdAt INTEGER NOT NULL,
        targetMinutes INTEGER
      )
    ''');
  }

  Future<List<Todo>> getAllTodos() async {
    final db = await database;
    final maps = await db.query('todos', orderBy: 'createdAt DESC');
    return maps.map((map) => Todo.fromMap(map)).toList();
  }

  Future<List<Todo>> getDailyTodos() async {
    final db = await database;
    final maps = await db.query(
      'todos',
      where: 'type = ?',
      whereArgs: [0],
      orderBy: 'createdAt DESC',
    );
    return maps.map((map) => Todo.fromMap(map)).toList();
  }

  Future<List<Todo>> getSpecialTodos() async {
    final db = await database;
    final maps = await db.query(
      'todos',
      where: 'type = ?',
      whereArgs: [1],
      orderBy: 'dueDate ASC',
    );
    return maps.map((map) => Todo.fromMap(map)).toList();
  }

  Future<void> insertTodo(Todo todo) async {
    final db = await database;
    await db.insert('todos', todo.toMap());
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await database;
    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo(String id) async {
    final db = await database;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> resetDailyTodos() async {
    final db = await database;
    await db.update(
      'todos',
      {'isCompleted': 0},
      where: 'type = ?',
      whereArgs: [0],
    );
  }

  Future<void> deleteCompletedSpecialTodos() async {
    final db = await database;
    await db.delete(
      'todos',
      where: 'type = ? AND isCompleted = ?',
      whereArgs: [1, 1],
    );
  }
}