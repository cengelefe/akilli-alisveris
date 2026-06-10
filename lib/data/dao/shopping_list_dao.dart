import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/shopping_list.dart';

class ShoppingListDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> insert(ShoppingList list) async {
    Database db = await _dbHelper.database;
    return await db.insert(DatabaseHelper.tableShoppingList, list.toJson());
  }

  Future<List<ShoppingList>> getAllLists() async {
    Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(DatabaseHelper.tableShoppingList);
    return List.generate(maps.length, (i) {
      return ShoppingList.fromJson(maps[i]);
    });
  }

  Future<int> update(ShoppingList list) async {
    Database db = await _dbHelper.database;
    return await db.update(
      DatabaseHelper.tableShoppingList,
      list.toJson(),
      where: 'id = ?',
      whereArgs: [list.id],
    );
  }

  Future<int> delete(int id) async {
    Database db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.tableShoppingList,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
