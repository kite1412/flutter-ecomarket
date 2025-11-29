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
      version: 5,
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
          image_path TEXT,
          quantity INTEGER DEFAULT 1,
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
          status TEXT CHECK(status IN ('pending','dibayar')),
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
        await db.execute('''
        CREATE TABLE balances (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          amount REAL DEFAULT 0.0,
          currency TEXT DEFAULT 'IDR',
          updated_at TEXT,
          created_at TEXT,
          FOREIGN KEY(user_id) REFERENCES users(id)
        );
        ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
          CREATE TABLE IF NOT EXISTS balances (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            amount REAL DEFAULT 0.0,
            currency TEXT DEFAULT 'IDR',
            updated_at TEXT,
            created_at TEXT,
            FOREIGN KEY(user_id) REFERENCES users(id)
          );
          ''');
        }
        if (oldVersion < 3) {
          try {
            await db.execute('ALTER TABLE items ADD COLUMN quantity INTEGER DEFAULT 1');
          } catch (_) {}
        }
        if (oldVersion < 4) {
          // Rebuild transactions table with status enum constraint
          try {
            final hasTx = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='transactions'");
            if (hasTx.isNotEmpty) {
              await db.execute('ALTER TABLE transactions RENAME TO transactions_old');
            }
            await db.execute('''
            CREATE TABLE transactions (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              buyer_id INTEGER,
              item_id INTEGER,
              price REAL,
              status TEXT CHECK(status IN ('pending','dibayar')),
              created_at TEXT,
              FOREIGN KEY(buyer_id) REFERENCES users(id),
              FOREIGN KEY(item_id) REFERENCES items(id)
            );
            ''');
            final hasOld = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='transactions_old'");
            if (hasOld.isNotEmpty) {
              await db.execute('''
              INSERT INTO transactions (id,buyer_id,item_id,price,status,created_at)
              SELECT id,buyer_id,item_id,price,
                CASE
                  WHEN lower(status) IN ('pending','dibayar') THEN lower(status)
                  WHEN status = 'Belum dibayar' THEN 'pending'
                  WHEN status = 'Menunggu' THEN 'pending'
                  ELSE 'pending'
                END,
                created_at
              FROM transactions_old;
              ''');
              await db.execute('DROP TABLE transactions_old');
            }
          } catch (_) {}
        }
        if (oldVersion < 5) {
          // Add image_path column to items
          try {
            await db.execute('ALTER TABLE items ADD COLUMN image_path TEXT');
          } catch (_) {}
        }
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

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final database = await db;
    final rows = await database.query('users', where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isNotEmpty ? rows.first : null;
  }

  Future<int> updateUser(int id, Map<String, dynamic> fields) async {
    final database = await db;
    return database.update('users', fields, where: 'id = ?', whereArgs: [id]);
  }

  // Items
  Future<int> insertItem(Map<String, dynamic> item) async {
    final database = await db;
    return database.insert('items', item);
  }

  Future<Map<String, dynamic>?> getItem(int id) async {
    final database = await db;
    final rows = await database.query('items', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    final row = Map<String, dynamic>.from(rows.first);
    // Surface images list for UI compatibility
    final img = row['image_path'];
    if (img != null && (img as Object).toString().isNotEmpty) {
      row['images'] = [img.toString()];
    }
    return row;
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
    final rows = await database.query('items', where: where, whereArgs: whereArgs, orderBy: 'created_at DESC');
    // Map image_path -> images list to keep UI simple
    return rows.map((r) {
      final row = Map<String, dynamic>.from(r);
      final img = row['image_path'];
      if (img != null && (img as Object).toString().isNotEmpty) {
        row['images'] = [img.toString()];
      }
      return row;
    }).toList();
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

  // Balances
  Future<Map<String, dynamic>?> getBalance(int userId) async {
    final database = await db;
    final rows = await database.query('balances', where: 'user_id = ?', whereArgs: [userId], limit: 1);
    return rows.isNotEmpty ? rows.first : null;
  }

  Future<int> createBalance(int userId, {double amount = 0.0, String currency = 'IDR'}) async {
    final database = await db;
    final nowIso = DateTime.now().toIso8601String();
    return database.insert('balances', {
      'user_id': userId,
      'amount': amount,
      'currency': currency,
      'updated_at': nowIso,
      'created_at': nowIso,
    });
  }

  Future<Map<String, dynamic>> ensureBalance(int userId) async {
    final existing = await getBalance(userId);
    if (existing != null) return existing;
    final id = await createBalance(userId);
    return (await getBalance(userId)) ?? {'user_id': userId, 'amount': 0.0, 'currency': 'IDR'};
  }

  Future<int> addToBalance(int userId, double delta) async {
    final database = await db;
    final nowIso = DateTime.now().toIso8601String();
    // Ensure exists
    await ensureBalance(userId);
    return database.rawUpdate(
      'UPDATE balances SET amount = amount + ?, updated_at = ? WHERE user_id = ?',
      [delta, nowIso, userId],
    );
  }
}
