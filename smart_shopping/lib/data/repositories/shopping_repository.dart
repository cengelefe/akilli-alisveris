import '../dao/category_dao.dart';
import '../dao/product_dao.dart';
import '../dao/shopping_list_dao.dart';
import '../dao/list_item_dao.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/shopping_list.dart';
import '../models/list_item.dart';
import '../models/user_profile.dart';
import '../database/database_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ShoppingRepository {
  final CategoryDao _categoryDao = CategoryDao();
  final ProductDao _productDao = ProductDao();
  final ShoppingListDao _shoppingListDao = ShoppingListDao();
  final ListItemDao _listItemDao = ListItemDao();

  // --- User Profile ---
  Future<UserProfile?> getUserProfile() async {
    final activeId = await getActiveUserId();
    if (activeId != null && activeId != -1) {
      final user = await getUserProfileById(activeId);
      if (user != null) return user;
    }
    // Fallback to first user
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(DatabaseHelper.tableUserProfile, limit: 1);
    if (maps.isNotEmpty) {
      return UserProfile.fromMap(maps.first);
    }
    return null;
  }

  Future<UserProfile?> getUserProfileById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      DatabaseHelper.tableUserProfile,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return UserProfile.fromMap(maps.first);
    }
    return null;
  }

  Future<void> saveActiveUserId(int id) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/active_user.txt');
      await file.writeAsString(id.toString());
    } catch (_) {}
  }

  Future<int?> getActiveUserId() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/active_user.txt');
      if (await file.exists()) {
        final content = await file.readAsString();
        return int.tryParse(content.trim());
      }
    } catch (_) {}
    return null;
  }

  Future<void> clearActiveUserId() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/active_user.txt');
      if (await file.exists()) {
        await file.writeAsString('-1');
      }
    } catch (_) {}
  }

  Future<int> addUserProfile(UserProfile profile) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert(DatabaseHelper.tableUserProfile, profile.toMap());
  }

  Future<UserProfile?> verifyUserCredentials(String email, String password) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      DatabaseHelper.tableUserProfile,
      where: 'email = ? AND password = ?',
      whereArgs: [email.trim(), password],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return UserProfile.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUserProfile(UserProfile profile) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      DatabaseHelper.tableUserProfile,
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  // --- Category ---
  Future<List<Category>> getCategories() => _categoryDao.getAllCategories();
  Future<int> addCategory(Category category) => _categoryDao.insert(category);

  // --- Product ---
  Future<List<Product>> getProducts() => _productDao.getAllProducts();
  Future<List<Product>> getProductsByCategory(int categoryId) => _productDao.getProductsByCategory(categoryId);
  Future<int> addProduct(Product product) => _productDao.insert(product);
  Future<int> updateProduct(Product product) => _productDao.update(product);
  Future<int> deleteProduct(int id) => _productDao.delete(id);

  // --- Shopping List ---
  Future<List<ShoppingList>> getShoppingLists() => _shoppingListDao.getAllLists();
  Future<int> addShoppingList(ShoppingList list) => _shoppingListDao.insert(list);
  Future<int> updateShoppingList(ShoppingList list) => _shoppingListDao.update(list);
  Future<int> deleteShoppingList(int id) => _shoppingListDao.delete(id);

  // --- List Item ---
  Future<List<ListItem>> getListItems(int listId) => _listItemDao.getItemsForList(listId);
  Future<List<ListItem>> getAllListItems() => _listItemDao.getAllItems();
  Future<int> addListItem(ListItem item) => _listItemDao.insert(item);
  Future<int> updateListItem(ListItem item) => _listItemDao.update(item);
  Future<int> deleteListItem(int id) => _listItemDao.delete(id);

  // --- Reset DB ---
  Future<void> clearShoppingData() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(DatabaseHelper.tableListItem);
    await db.delete(DatabaseHelper.tableShoppingList);
  }
}
