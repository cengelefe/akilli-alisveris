import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/category.dart';

class CategoryDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> insert(Category category) async {
    Database db = await _dbHelper.database;
    return await db.insert(DatabaseHelper.tableCategory, category.toJson());
  }

  Future<List<Category>> getAllCategories() async {
    Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(DatabaseHelper.tableCategory);
    return List.generate(maps.length, (i) {
      return Category.fromJson(maps[i]);
    });
  }

  Future<int> update(Category category) async {
    Database db = await _dbHelper.database;
    return await db.update(
      DatabaseHelper.tableCategory,
      category.toJson(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> delete(int id) async {
    Database db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.tableCategory,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
