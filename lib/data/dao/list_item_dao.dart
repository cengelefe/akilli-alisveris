import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/list_item.dart';

class ListItemDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> insert(ListItem item) async {
    Database db = await _dbHelper.database;
    return await db.insert(DatabaseHelper.tableListItem, item.toJson());
  }

  Future<List<ListItem>> getItemsForList(int listId) async {
    Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableListItem,
      where: 'listId = ?',
      whereArgs: [listId],
    );
    return List.generate(maps.length, (i) {
      return ListItem.fromJson(maps[i]);
    });
  }
  
  Future<List<ListItem>> getAllItems() async {
    Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(DatabaseHelper.tableListItem);
    return List.generate(maps.length, (i) {
      return ListItem.fromJson(maps[i]);
    });
  }

  Future<int> update(ListItem item) async {
    Database db = await _dbHelper.database;
    return await db.update(
      DatabaseHelper.tableListItem,
      item.toJson(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> delete(int id) async {
    Database db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.tableListItem,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
