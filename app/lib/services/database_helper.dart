import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/subscription.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('substitch.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE subscriptions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        cost REAL NOT NULL,
        currency TEXT NOT NULL,
        firstPaymentDate TEXT NOT NULL,
        cycle TEXT NOT NULL,
        description TEXT,
        iconUrl TEXT
      )
    ''');
  }

  Future<int> create(Subscription subscription) async {
    final db = await instance.database;
    final id = await db.insert('subscriptions', subscription.toJson());
    return id;
  }

  Future<Subscription> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'subscriptions',
      columns: ['id', 'name', 'cost', 'currency', 'firstPaymentDate', 'cycle', 'description', 'iconUrl'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Subscription.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Subscription>> readAllSubscriptions() async {
    final db = await instance.database;
    final result = await db.query('subscriptions');
    return result.map((json) => Subscription.fromJson(json)).toList();
  }

  Future<int> update(Subscription subscription) async {
    final db = await instance.database;
    return db.update(
      'subscriptions',
      subscription.toJson(),
      where: 'id = ?',
      whereArgs: [subscription.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'subscriptions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
