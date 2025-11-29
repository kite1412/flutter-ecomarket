import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class LocalDb {
  static final LocalDb instance = LocalDb._();
  LocalDb._();

  Database? _db;
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'ecomarket.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT UNIQUE,
          password TEXT,
          address TEXT,
          created_at TEXT
        );
        ''');
        await db.execute('''
        CREATE TABLE items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          title TEXT,
          description TEXT,
          category TEXT,
          condition TEXT,
          weight_kg REAL,
          price REAL,
          status TEXT,
          created_at TEXT,
          FOREIGN KEY(user_id) REFERENCES users(id)
        );
        ''');
        await db.execute('''
        CREATE TABLE transactions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          buyer_id INTEGER,
          item_id INTEGER,
          price REAL,
          status TEXT,
          created_at TEXT,
          FOREIGN KEY(buyer_id) REFERENCES users(id),
          FOREIGN KEY(item_id) REFERENCES items(id)
        );
        ''');
        await db.execute('''
        CREATE TABLE reviews (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          item_id INTEGER,
          rating INTEGER,
          comment TEXT,
          created_at TEXT,
          FOREIGN KEY(user_id) REFERENCES users(id),
          FOREIGN KEY(item_id) REFERENCES items(id)
        );
        ''' );
      },
    );
  }

  // Users
  Future<int> upsertUser(Map<String, dynamic> user) async {
    final database = await db;
    // Try update by email; if no row, insert
    final existing = await database.query('users', where: 'email = ?', whereArgs: [user['email']]);
    if (existing.isNotEmpty) {
      return database.update('users', user, where: 'email = ?', whereArgs: [user['email']]);
    }
    return database.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final database = await db;
    final rows = await database.query('users', where: 'email = ?', whereArgs: [email], limit: 1);
    return rows.isNotEmpty ? rows.first : null;
  }

  // Items
  Future<int> insertItem(Map<String, dynamic> item) async {
    final database = await db;
    return database.insert('items', item);
  }

  Future<List<Map<String, dynamic>>> listItems({int? userId, String? status}) async {
    final database = await db;
    String? where;
    List<Object?> whereArgs = [];
    if (userId != null) {
      where = (where == null) ? 'user_id = ?' : '$where AND user_id = ?';
      whereArgs.add(userId);
    }
    if (status != null) {
      where = (where == null) ? 'status = ?' : '$where AND status = ?';
      whereArgs.add(status);
    }
    return database.query('items', where: where, whereArgs: whereArgs, orderBy: 'created_at DESC');
  }

  Future<int> updateItem(int id, Map<String, dynamic> fields) async {
    final database = await db;
    return database.update('items', fields, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteItem(int id) async {
    final database = await db;
    return database.delete('items', where: 'id = ?', whereArgs: [id]);
  }

  // Transactions
  Future<int> insertTransaction(Map<String, dynamic> tx) async {
    final database = await db;
    return database.insert('transactions', tx);
  }

  Future<List<Map<String, dynamic>>> listTransactions({int? buyerId, String? status}) async {
    final database = await db;
    String? where;
    List<Object?> whereArgs = [];
    if (buyerId != null) {
      where = (where == null) ? 'buyer_id = ?' : '$where AND buyer_id = ?';
      whereArgs.add(buyerId);
    }
    if (status != null) {
      where = (where == null) ? 'status = ?' : '$where AND status = ?';
      whereArgs.add(status);
    }
    return database.query('transactions', where: where, whereArgs: whereArgs, orderBy: 'created_at DESC');
  }

  // Reviews
  Future<int> insertReview(Map<String, dynamic> review) async {
    final database = await db;
    return database.insert('reviews', review);
  }

  Future<List<Map<String, dynamic>>> listReviews({int? itemId, int? userId}) async {
    final database = await db;
    String? where;
    List<Object?> whereArgs = [];
    if (itemId != null) {
      where = (where == null) ? 'item_id = ?' : '$where AND item_id = ?';
      whereArgs.add(itemId);
    }
    if (userId != null) {
      where = (where == null) ? 'user_id = ?' : '$where AND user_id = ?';
      whereArgs.add(userId);
    }
    return database.query('reviews', where: where, whereArgs: whereArgs, orderBy: 'created_at DESC');
  }
}
