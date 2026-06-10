import 'package:flutter/material.dart';
import '../../data/database/database_helper.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'tr';

  String get currentLanguage => _currentLanguage;

  LanguageProvider() {
    _loadLanguageFromDb();
  }

  Future<void> _loadLanguageFromDb() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final maps = await db.query(DatabaseHelper.tableUserProfile, limit: 1);
      if (maps.isNotEmpty) {
        _currentLanguage = maps.first['language'] as String? ?? 'tr';
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> setLanguage(String languageCode) async {
    if (languageCode == 'tr' || languageCode == 'en') {
      _currentLanguage = languageCode;
      notifyListeners();
      
      // Persist to DB
      try {
        final db = await DatabaseHelper.instance.database;
        await db.update(
          DatabaseHelper.tableUserProfile,
          {'language': languageCode},
          where: 'id = ?',
          whereArgs: [1],
        );
      } catch (_) {}
    }
  }

  String translateCategory(String name) {
    if (_currentLanguage == 'en') {
      const map = {
        'Meyve & Sebze': 'Fruits & Vegetables',
        'Süt Ürünleri': 'Dairy Products',
        'Fırın': 'Bakery',
        'Et & Tavuk': 'Meat & Poultry',
        'Atıştırmalık': 'Snacks',
        'Temizlik': 'Cleaning',
        'Diğer': 'Other',
      };
      return map[name] ?? name;
    }
    return name;
  }

  String translateProduct(String name) {
    if (_currentLanguage == 'en') {
      const map = {
        'Domates': 'Tomato',
        'Salatalık': 'Cucumber',
        'Patates': 'Potato',
        'Kuru Soğan': 'Onion',
        'Muz': 'Banana',
        'Elma (Amasya)': 'Apple (Amasya)',
        'Çilek': 'Strawberry',
        'Havuç': 'Carrot',
        'Ispanak': 'Spinach',
        'Kıvırcık Marul': 'Lettuce',
        'Limon': 'Lemon',
        'Sivri Biber': 'Green Pepper',
        'Portakal': 'Orange',
        'Karpuz': 'Watermelon',
        'Sarımsak': 'Garlic',
        'Tam Yağlı Süt (1 Lt)': 'Whole Milk (1 L)',
        'Yarım Yağlı Yoğurt (2 Kg)': 'Low-Fat Yogurt (2 Kg)',
        'Klasik Beyaz Peynir': 'Classic Feta Cheese',
        'Taze Kaşar Peyniri': 'Kashar Cheese',
        'Süzme Yoğurt': 'Strained Yogurt',
        'Tereyağı': 'Butter',
        'Ayran (1.5 Lt)': 'Ayran (1.5 L)',
        'Labne Peyniri': 'Labneh Cheese',
        'Sıvı Krema': 'Liquid Cream',
        'Lor Peyniri': 'Curd Cheese',
        'Sade Kefir': 'Plain Kefir',
        'Manda Kaymağı': 'Buffalo Clotted Cream',
        'İzmir Tulum Peyniri': 'Izmir Tulum Cheese',
        'Çilekli Meyveli Yoğurt': 'Strawberry Yogurt',
        'Çikolatalı Puding': 'Chocolate Pudding',
        'Beyaz Ekmek': 'White Bread',
        'Tam Buğday Ekmeği': 'Whole Wheat Bread',
        'Sokak Simiti': 'Turkish Bagel (Simit)',
        'Sade Poğaça': 'Plain Pastry',
        'Taze Yufka (4\'lü)': 'Fresh Phyllo Dough (4 pcs)',
        'Lavaş Ekmek': 'Lavash Bread',
        'Klasik Tost Ekmeği': 'Classic Toast Bread',
        'Çikolatalı Kruvasan': 'Chocolate Croissant',
        'Tuzlu Galeta': 'Salty Biscuit/Galeta',
        'Hamburger Ekmeği': 'Hamburger Buns',
        'Damla Çikolatalı Kurabiye': 'Chocolate Chip Cookie',
        'Havuçlu Tarçınlı Kek': 'Carrot Cinnamon Cake',
        'Milföy Hamuru': 'Puff Pastry',
        'Çavdar Ekmeği': 'Rye Bread',
        'Sade Grissini': 'Plain Breadsticks',
        'Dana Kıyma (%20 Yağlı - 1 Kg)': 'Minced Beef (20% Fat - 1 Kg)',
        'Dana Kuşbaşı (1 Kg)': 'Diced Beef (1 Kg)',
        'Tavuk Göğsü (Bonfile - 1 Kg)': 'Chicken Breast (Fillet - 1 Kg)',
        'Tavuk Baget (1 Kg)': 'Chicken Drumsticks (1 Kg)',
        'Hazır Kasap Köfte (1 Kg)': 'Prepared Meatballs (1 Kg)',
        'Dana Antrikot (1 Kg)': 'Ribeye Steak (1 Kg)',
        'Tavuk Kanat (1 Kg)': 'Chicken Wings (1 Kg)',
        'Kuzu Pirzola (1 Kg)': 'Lamb Chops (1 Kg)',
        'Kasap Sucuk': 'Turkish Garlic Sausage (Sucuk)',
        'Macar Salam': 'Hungarian Salami',
        'Kokteyl Sosis': 'Cocktail Sausages',
        'Kayseri Pastırması': 'Kayseri Pastirma',
        'Hindi Füme': 'Smoked Turkey',
        'Dana Bonfile (1 Kg)': 'Beef Tenderloin (1 Kg)',
        'Kuzu Gerdan (1 Kg)': 'Lamb Neck (1 Kg)',
        'Çikolatalı Gofret': 'Chocolate Wafer',
        'Sade Patates Cipsi': 'Plain Potato Chips',
        'Tuzlu Yer Fıstığı': 'Salted Peanuts',
        'Kavrulmuş Ay Çekirdeği': 'Roasted Sunflower Seeds',
        'Meyveli Jelibon': 'Fruit Gummy Bears',
        'Yulaflı Bisküvi': 'Oat Cookies',
        'Patlamış Mısır': 'Popcorn',
        'Sütlü Çikolata Barı': 'Milk Chocolate Bar',
        'Tuzlu Kraker': 'Salted Crackers',
        'Antep Fıstıklı Lokum': 'Pistachio Turkish Delight',
        'Çekirdeksiz Kuru Üzüm': 'Raisins',
        'Çiğ Badem İçi': 'Raw Almonds',
        'Kremalı Gofret': 'Cream Wafer',
        'Orman Meyveli Bar': 'Forest Fruit Bar',
        'Karışık Kuruyemiş': 'Mixed Nuts',
        'Toz Çamaşır Deterjanı': 'Powder Laundry Deterjan',
        'Bulaşık Makinesi Tableti': 'Dishwasher Tablets',
        'Elde Bulaşık Deterjanı (Sıvı)': 'Liquid Dish Soap',
        'Lavanta Kokulu Yüzey Temizleyici': 'Lavender Surface Cleaner',
        'Ultra Yoğun Çamaşır Suyu': 'Ultra Bleach',
        'Konsantre Çamaşır Yumuşatıcısı': 'Concentrated Fabric Softener',
        'Cam Temizleme Spreyi': 'Glass Cleaner Spray',
        'Antibakteriyel Sıvı Sabun': 'Antibacterial Liquid Soap',
        'Mutfak Yağ Çözücü': 'Kitchen Degreaser',
        'Banyo Kireç Çözücü': 'Bathroom Limescale Remover',
        'Bulaşık Süngeri (4\'lü)': 'Dish Sponge (4 pack)',
        'Mikrofiber Temizlik Bezi': 'Microfiber Cleaning Cloth',
        'Büzgülü Çöp Poşeti': 'Drawstring Trash Bags',
        '2 Katlı Kağıt Havlu (6\'lı)': '2-Ply Paper Towels (6 pack)',
        'Parfümlü Tuvalet Kağıdı (16\'lı)': 'Scented Toilet Paper (16 pack)',
        'Sızma Zeytinyağı (1 Lt)': 'Extra Virgin Olive Oil (1 L)',
        'Ayçiçek Yağı (5 Lt)': 'Sunflower Oil (5 L)',
        'Toz Şeker (1 Kg)': 'Granulated Sugar (1 Kg)',
        'İyotlu Sofra Tuzu': 'Iodized Table Salt',
        'Geleneksel Türk Kahvesi': 'Traditional Turkish Coffee',
        'Filiz Siyah Çay (1 Kg)': 'Black Tea (1 Kg)',
        'Spagetti Makarna': 'Spaghetti Pasta',
        'Pilavlık Yerli Pirinç': 'Rice for Pilaf',
        'Kırmızı Mercimek': 'Red Lentils',
        'Pilavlık Bulgur': 'Bulgur Wheat',
        'Buğday Unu (2 Kg)': 'Wheat Flour (2 Kg)',
        'Domates Salçası': 'Tomato Paste',
        'Organik Yumurta (15\'li)': 'Organic Eggs (15 pcs)',
        'Doğal Maden Suyu (6\'lı)': 'Natural Mineral Water (6 pack)',
        'Pet Şişe Su (5 Lt)': 'Bottled Water (5 L)',
      };
      return map[name] ?? name;
    }
    return name;
  }

  // Translation mapping
  static final Map<String, Map<String, String>> _localizedValues = {
    'tr': {
      'app_title': 'Akıllı Alışveriş',
      'login_title': 'Giriş Yap',
      'login_subtitle': 'Akıllı Alışveriş Dünyasına Hoş Geldiniz',
      'email': 'E-posta',
      'password': 'Şifre',
      'login_btn': 'Giriş Yap',
      'login_error': 'E-posta veya şifre hatalı!',
      'dashboard_title': 'Akıllı Alışveriş Listesi',
      'active_lists': 'Aktif Listeler',
      'completed_lists': 'Tamamlanan Listeler',
      'total_spend': 'Toplam Harcama',
      'pending_items': 'Bekleyen Ürünler',
      'search_hint': 'Liste ara...',
      'new_list_title': 'Yeni Liste Oluştur',
      'new_list_hint': 'Liste adı girin',
      'cancel': 'İptal',
      'create': 'Oluştur',
      'settings_title': 'Ayarlar',
      'notifications': 'Bildirimler',
      'language': 'Dil',
      'clear_data': 'Tüm Verileri Temizle',
      'clear_data_success': 'Tüm veriler temizlendi.',
      'profile_title': 'Profil',
      'edit_profile': 'Profili Düzenle',
      'name': 'Ad Soyad',
      'save': 'Kaydet',
      'stats_title': 'Harcama Analizi',
      'favorites_title': 'Sık Kullanılanlar',
      'add_product': 'Ürün Ekle',
      'product_name': 'Ürün Adı',
      'price': 'Birim Fiyat (₺)',
      'quantity': 'Adet / Miktar',
      'category': 'Kategori',
      'no_data': 'Henüz veri bulunmuyor.',
      'no_lists': 'Henüz hiç listeniz yok.',
      'no_items_in_list': 'Bu listede henüz ürün yok.\nÜrün eklemek için aşağıdaki butonu kullanın.',
      'total_amount': 'Toplam Tutar',
      'select_category': 'Kategori Seçin',
      'suggested_products': 'Önerilen Ürünler',
      'theme_mode': 'Tema Modu',
      'menu': 'Menü',
      'total_lists': 'Toplam Liste',
      'completed': 'Tamamlanan',
      'active': 'Aktif',
      'delete_confirm_title': 'Silmek İstiyor musunuz?',
      'delete_confirm_desc': 'Bu liste ve içindeki tüm ürünler silinecek.',
      'delete': 'Sil',
      'new_list_label': 'Liste Adı (Örn: Haftalık Market)',
      'register_title': 'Kayıt Ol',
      'register_btn': 'Kayıt Ol',
      'register_success': 'Kayıt başarılı! Şimdi giriş yapabilirsiniz.',
      'register_error': 'Kayıt sırasında bir hata oluştu.',
      'already_have_account': 'Zaten hesabınız var mı? Giriş Yapın',
      'dont_have_account': 'Hesabınız yok mu? Kayıt Olun',
      'fullname_hint': 'Ad Soyad giriniz',
      'product_select': 'Ürün Seçin',
      'form_error_select': 'Lütfen kategori ve ürün seçin.',
      'list_add_btn': 'Listeye Ekle',
      'logout': 'Çıkış Yap',
    },
    'en': {
      'app_title': 'Smart Shopping',
      'login_title': 'Login',
      'login_subtitle': 'Welcome to Smart Shopping World',
      'email': 'Email',
      'password': 'Password',
      'login_btn': 'Log In',
      'login_error': 'Invalid email or password!',
      'dashboard_title': 'Smart Shopping List',
      'active_lists': 'Active Lists',
      'completed_lists': 'Completed Lists',
      'total_spend': 'Total Spend',
      'pending_items': 'Pending Items',
      'search_hint': 'Search lists...',
      'new_list_title': 'Create New List',
      'new_list_hint': 'Enter list name',
      'cancel': 'Cancel',
      'create': 'Create',
      'settings_title': 'Settings',
      'notifications': 'Notifications',
      'language': 'Language',
      'clear_data': 'Clear All Data',
      'clear_data_success': 'All data has been cleared.',
      'profile_title': 'Profile',
      'edit_profile': 'Edit Profile',
      'name': 'Full Name',
      'save': 'Save',
      'stats_title': 'Spend Analysis',
      'favorites_title': 'Favorites',
      'add_product': 'Add Product',
      'product_name': 'Product Name',
      'price': 'Unit Price (₺)',
      'quantity': 'Quantity / Amount',
      'category': 'Category',
      'no_data': 'No data found yet.',
      'no_lists': 'No lists yet.',
      'no_items_in_list': 'There are no items in this list.\nUse the button below to add products.',
      'total_amount': 'Total Amount',
      'select_category': 'Select Category',
      'suggested_products': 'Suggested Products',
      'theme_mode': 'Theme Mode',
      'menu': 'Menu',
      'total_lists': 'Total Lists',
      'completed': 'Completed',
      'active': 'Active',
      'delete_confirm_title': 'Delete Shopping List?',
      'delete_confirm_desc': 'This list and all its products will be deleted.',
      'delete': 'Delete',
      'new_list_label': 'List Name (e.g. Weekly Groceries)',
      'register_title': 'Register',
      'register_btn': 'Register',
      'register_success': 'Registration successful! You can now log in.',
      'register_error': 'An error occurred during registration.',
      'already_have_account': 'Already have an account? Log In',
      'dont_have_account': 'Don\'t have an account? Register',
      'fullname_hint': 'Please enter your Full Name',
      'product_select': 'Select Product',
      'form_error_select': 'Please select category and product.',
      'list_add_btn': 'Add to List',
      'logout': 'Logout',
    }
  };

  String translate(String key) {
    return _localizedValues[_currentLanguage]?[key] ?? key;
  }
}
