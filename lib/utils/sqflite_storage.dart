import 'package:e_cart_flutter/models/model_produts_list.dart';
import 'package:sqflite/sqflite.dart';

class SqFlightStorage {
  static final SqFlightStorage _instance = SqFlightStorage._internal();

  factory SqFlightStorage() => _instance;

  SqFlightStorage._internal();

  Database? _database;

  Future<Database> get db async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    return await openDatabase(
      'products.db',
      version: 1,
      onCreate: (db, version) async {
        // Create tables here
        await db.execute('''
              CREATE TABLE IF NOT EXISTS products (
                id INTEGER PRIMARY KEY,
                title TEXT,
                price REAL,
                description TEXT,
                category TEXT,
                image TEXT,
                rate REAL,
                count INTEGER,
                favorite INTEGER DEFAULT 0
              )
            ''');

        await db.execute('''
              CREATE TABLE IF NOT EXISTS cart (
                id INTEGER PRIMARY KEY,
                title TEXT,
                price REAL,
                description TEXT,
                category TEXT,
                image TEXT,
                rate REAL,
                count INTEGER,
                favorite INTEGER DEFAULT 0
              )
            ''');
        // Add other table creation statements as needed
      },
    );
  }

  Future<void> insertAllProducts(List<ProductDetailsModel> products) async {
    final database = await db;
    Batch batch = database.batch();
    for (var product in products) {
      batch.insert(
        'products',
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<ProductDetailsModel>> getAllProducts() async {
    final database = await db;
    final List<Map<String, dynamic>> maps = await database.query('products');
    return List.generate(maps.length, (i) {
      return ProductDetailsModel.fromMap(maps[i]);
    });
  }

  Future<void> updateFavoriteStatus(int productId, bool isFavorite) async {
    final database = await db;
    await database.update(
      'products',
      {'favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [productId],
    );

  }

 Future<void> insertProductToCart(ProductDetailsModel product) async {
    final database = await db;
    await database.insert('cart', product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ProductDetailsModel>> getAllCartProducts() async {
    final database = await db;
    final List<Map<String, dynamic>> maps = await database.query('cart');
    return List.generate(maps.length, (i) {
      return ProductDetailsModel.fromMap(maps[i]);
    });
  }

  deleteCartProduct(int i) async {
    final database = await db;
    database.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [i],
    );
  }

  Future<List<ProductDetailsModel>>  getCartTotalAmount() async {
    final database = await db;
    final List<Map<String, dynamic>> maps = await database.query('cart');
    return List.generate(maps.length, (i) {
      return ProductDetailsModel.fromMap(maps[i]);
    });
  }


  Future<List<ProductDetailsModel>> getFavoriteStatusItems() async {
    final database = await db;
    // Query to get all products with favorite status
    final List<Map<String, dynamic>> maps = await database.query(
      'products',
      where: 'favorite = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) {
      return ProductDetailsModel.fromMap(maps[i]);
    });
  }

}
