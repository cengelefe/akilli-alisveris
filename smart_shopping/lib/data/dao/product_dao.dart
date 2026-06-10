import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/product.dart';

class ProductDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> insert(Product product) async {
    Database db = await _dbHelper.database;
    return await db.insert(DatabaseHelper.tableProduct, product.toJson());
  }

  Future<List<Product>> getAllProducts() async {
    Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(DatabaseHelper.tableProduct);
    return List.generate(maps.length, (i) {
      return Product.fromJson(maps[i]);
    });
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableProduct,
      where: 'categoryId = ?',
      whereArgs: [categoryId],
    );
    return List.generate(maps.length, (i) {
      return Product.fromJson(maps[i]);
    });
  }

  Future<int> update(Product product) async {
    Database db = await _dbHelper.database;
    return await db.update(
      DatabaseHelper.tableProduct,
      product.toJson(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> delete(int id) async {
    Database db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.tableProduct,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
