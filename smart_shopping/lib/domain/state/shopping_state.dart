import 'package:flutter/material.dart';
import '../../data/repositories/shopping_repository.dart';
import '../../data/models/category.dart';
import '../../data/models/product.dart';
import '../../data/models/shopping_list.dart';
import '../../data/models/list_item.dart';
import '../../data/models/user_profile.dart';
import 'package:intl/intl.dart';

class ShoppingState extends ChangeNotifier {
  final ShoppingRepository _repository = ShoppingRepository();

  List<Category> _categories = [];
  List<Product> _products = [];
  List<ShoppingList> _shoppingLists = [];
  List<ListItem> _currentListItems = [];
  List<ListItem> _allListItems = []; // For stats
  UserProfile? _userProfile;

  List<Category> get categories => _categories;
  List<Product> get products => _products;
  List<ShoppingList> get shoppingLists => _shoppingLists;
  List<ListItem> get currentListItems => _currentListItems;
  List<ListItem> get allListItems => _allListItems;
  UserProfile? get userProfile => _userProfile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ShoppingState() {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    _categories = await _repository.getCategories();
    _products = await _repository.getProducts();
    _shoppingLists = await _repository.getShoppingLists();
    _allListItems = await _repository.getAllListItems();
    _userProfile = await _repository.getUserProfile();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _repository.updateUserProfile(profile);
    _userProfile = profile;
    notifyListeners();
  }

  Future<bool> registerUser(UserProfile profile) async {
    final result = await _repository.addUserProfile(profile);
    if (result > 0) {
      return true;
    }
    return false;
  }

  Future<bool> loginUser(String email, String password) async {
    final profile = await _repository.verifyUserCredentials(email, password);
    if (profile != null) {
      _userProfile = profile;
      await _repository.saveActiveUserId(profile.id!);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logoutUser() async {
    _userProfile = null;
    await _repository.clearActiveUserId();
    notifyListeners();
  }

  Future<void> clearAllData() async {
    await _repository.clearShoppingData();
    _shoppingLists = [];
    _currentListItems = [];
    _allListItems = [];
    notifyListeners();
  }

  // --- Shopping List Operations ---
  Future<void> createShoppingList(String title) async {
    final newList = ShoppingList(
      title: title,
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    await _repository.addShoppingList(newList);
    _shoppingLists = await _repository.getShoppingLists();
    notifyListeners();
  }

  Future<void> deleteShoppingList(int id) async {
    await _repository.deleteShoppingList(id);
    _shoppingLists = await _repository.getShoppingLists();
    notifyListeners();
  }

  Future<void> toggleListCompletion(ShoppingList list) async {
    final updatedList = list.copyWith(isCompleted: !list.isCompleted);
    await _repository.updateShoppingList(updatedList);
    _shoppingLists = await _repository.getShoppingLists();
    notifyListeners();
  }

  // --- List Item Operations ---
  Future<void> loadItemsForList(int listId) async {
    _currentListItems = await _repository.getListItems(listId);
    notifyListeners();
  }

  Future<void> _checkAndUpdateListCompletion(int listId) async {
    final listItems = _currentListItems.where((i) => i.listId == listId).toList();
    final allChecked = listItems.isNotEmpty && listItems.every((i) => i.isChecked);
    
    final listIndex = _shoppingLists.indexWhere((l) => l.id == listId);
    if (listIndex != -1) {
      final list = _shoppingLists[listIndex];
      if (list.isCompleted != allChecked) {
        final updatedList = list.copyWith(isCompleted: allChecked);
        await _repository.updateShoppingList(updatedList);
        _shoppingLists = await _repository.getShoppingLists();
      }
    }
  }

  Future<void> addListItem(ListItem item) async {
    await _repository.addListItem(item);
    await loadItemsForList(item.listId);
    await _checkAndUpdateListCompletion(item.listId);
    _allListItems = await _repository.getAllListItems();
    notifyListeners();
  }

  Future<void> updateListItemQuantity(ListItem item, int newQuantity) async {
    if (newQuantity < 1) return;
    final updatedItem = item.copyWith(quantity: newQuantity);
    await _repository.updateListItem(updatedItem);
    await loadItemsForList(item.listId);
    _allListItems = await _repository.getAllListItems();
    notifyListeners();
  }

  Future<void> toggleItemCheck(ListItem item) async {
    final updatedItem = item.copyWith(isChecked: !item.isChecked);
    await _repository.updateListItem(updatedItem);
    await loadItemsForList(item.listId);
    await _checkAndUpdateListCompletion(item.listId);
    _allListItems = await _repository.getAllListItems();
    notifyListeners();
  }

  Future<void> deleteListItem(int id, int listId) async {
    await _repository.deleteListItem(id);
    await loadItemsForList(listId);
    await _checkAndUpdateListCompletion(listId);
    _allListItems = await _repository.getAllListItems();
    notifyListeners();
  }

  // --- Product & Category Operations ---
  Future<void> addProduct(Product product) async {
    await _repository.addProduct(product);
    _products = await _repository.getProducts();
    notifyListeners();
  }

  double calculateTotalForList(int listId) {
    double total = 0;
    for (var item in _currentListItems) {
      if (item.listId == listId) {
        total += item.price * item.quantity;
      }
    }
    return total;
  }
}
