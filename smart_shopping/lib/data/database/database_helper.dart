import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "SmartShopping.db";
  static const _databaseVersion = 3;

  // Tablo isimleri
  static const tableCategory = 'CategoryTable';
  static const tableProduct = 'ProductTable';
  static const tableShoppingList = 'ShoppingListTable';
  static const tableListItem = 'ListItemTable';
  static const tableUserProfile = 'UserProfileTable';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCategory (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableProduct (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        categoryId INTEGER NOT NULL,
        defaultPrice REAL DEFAULT 0.0,
        FOREIGN KEY (categoryId) REFERENCES $tableCategory (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableShoppingList (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableListItem (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        listId INTEGER NOT NULL,
        productId INTEGER NOT NULL,
        price REAL DEFAULT 0.0,
        quantity INTEGER NOT NULL DEFAULT 1,
        isChecked INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (listId) REFERENCES $tableShoppingList (id) ON DELETE CASCADE,
        FOREIGN KEY (productId) REFERENCES $tableProduct (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableUserProfile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        language TEXT NOT NULL DEFAULT 'tr',
        notificationsEnabled INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Başlangıç verileri (Kategoriler ve Ürünler)
    await _insertInitialData(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('DROP TABLE IF EXISTS $tableListItem');
      await db.execute('DROP TABLE IF EXISTS $tableProduct');
      await db.execute('DROP TABLE IF EXISTS $tableCategory');
      await db.execute('DROP TABLE IF EXISTS $tableShoppingList');
      await db.execute('DROP TABLE IF EXISTS $tableUserProfile');
      await _onCreate(db, newVersion);
    }
  }

  Future _insertInitialData(Database db) async {
    // Seed default user profile
    await db.insert(tableUserProfile, {
      'name': 'Akıllı Kullanıcı',
      'email': 'user@smartshopping.com',
      'password': 'password123',
      'language': 'tr',
      'notificationsEnabled': 1
    });

    final categories = [
      {'name': 'Meyve & Sebze', 'icon': 'apple'},
      {'name': 'Süt Ürünleri', 'icon': 'cheese'},
      {'name': 'Fırın', 'icon': 'bread'},
      {'name': 'Et & Tavuk', 'icon': 'meat'},
      {'name': 'Atıştırmalık', 'icon': 'snack'},
      {'name': 'Temizlik', 'icon': 'clean'},
      {'name': 'Diğer', 'icon': 'other'},
    ];

    for (var cat in categories) {
      await db.insert(tableCategory, cat);
    }

    final products = [
      // 1. Meyve & Sebze (categoryId: 1)
      {'name': 'Domates', 'categoryId': 1, 'defaultPrice': 45.0},
      {'name': 'Salatalık', 'categoryId': 1, 'defaultPrice': 40.0},
      {'name': 'Patates', 'categoryId': 1, 'defaultPrice': 25.0},
      {'name': 'Kuru Soğan', 'categoryId': 1, 'defaultPrice': 20.0},
      {'name': 'Muz', 'categoryId': 1, 'defaultPrice': 75.0},
      {'name': 'Elma (Amasya)', 'categoryId': 1, 'defaultPrice': 35.0},
      {'name': 'Çilek', 'categoryId': 1, 'defaultPrice': 90.0},
      {'name': 'Havuç', 'categoryId': 1, 'defaultPrice': 30.0},
      {'name': 'Ispanak', 'categoryId': 1, 'defaultPrice': 40.0},
      {'name': 'Kıvırcık Marul', 'categoryId': 1, 'defaultPrice': 25.0},
      {'name': 'Limon', 'categoryId': 1, 'defaultPrice': 45.0},
      {'name': 'Sivri Biber', 'categoryId': 1, 'defaultPrice': 60.0},
      {'name': 'Portakal', 'categoryId': 1, 'defaultPrice': 35.0},
      {'name': 'Karpuz', 'categoryId': 1, 'defaultPrice': 80.0},
      {'name': 'Sarımsak', 'categoryId': 1, 'defaultPrice': 120.0},

      // 2. Süt Ürünleri (categoryId: 2)
      {'name': 'Tam Yağlı Süt (1 Lt)', 'categoryId': 2, 'defaultPrice': 42.0},
      {'name': 'Yarım Yağlı Yoğurt (2 Kg)', 'categoryId': 2, 'defaultPrice': 85.0},
      {'name': 'Klasik Beyaz Peynir', 'categoryId': 2, 'defaultPrice': 190.0},
      {'name': 'Taze Kaşar Peyniri', 'categoryId': 2, 'defaultPrice': 240.0},
      {'name': 'Süzme Yoğurt', 'categoryId': 2, 'defaultPrice': 65.0},
      {'name': 'Tereyağı', 'categoryId': 2, 'defaultPrice': 320.0},
      {'name': 'Ayran (1.5 Lt)', 'categoryId': 2, 'defaultPrice': 38.0},
      {'name': 'Labne Peyniri', 'categoryId': 2, 'defaultPrice': 45.0},
      {'name': 'Sıvı Krema', 'categoryId': 2, 'defaultPrice': 30.0},
      {'name': 'Lor Peyniri', 'categoryId': 2, 'defaultPrice': 70.0},
      {'name': 'Sade Kefir', 'categoryId': 2, 'defaultPrice': 40.0},
      {'name': 'Manda Kaymağı', 'categoryId': 2, 'defaultPrice': 110.0},
      {'name': 'İzmir Tulum Peyniri', 'categoryId': 2, 'defaultPrice': 280.0},
      {'name': 'Çilekli Meyveli Yoğurt', 'categoryId': 2, 'defaultPrice': 22.0},
      {'name': 'Çikolatalı Puding', 'categoryId': 2, 'defaultPrice': 18.0},

      // 3. Fırın (categoryId: 3)
      {'name': 'Beyaz Ekmek', 'categoryId': 3, 'defaultPrice': 15.0},
      {'name': 'Tam Buğday Ekmeği', 'categoryId': 3, 'defaultPrice': 30.0},
      {'name': 'Sokak Simiti', 'categoryId': 3, 'defaultPrice': 17.0},
      {'name': 'Sade Poğaça', 'categoryId': 3, 'defaultPrice': 15.0},
      {'name': 'Taze Yufka (4\'lü)', 'categoryId': 3, 'defaultPrice': 55.0},
      {'name': 'Lavaş Ekmek', 'categoryId': 3, 'defaultPrice': 35.0},
      {'name': 'Klasik Tost Ekmeği', 'categoryId': 3, 'defaultPrice': 45.0},
      {'name': 'Çikolatalı Kruvasan', 'categoryId': 3, 'defaultPrice': 50.0},
      {'name': 'Tuzlu Galeta', 'categoryId': 3, 'defaultPrice': 32.0},
      {'name': 'Hamburger Ekmeği', 'categoryId': 3, 'defaultPrice': 40.0},
      {'name': 'Damla Çikolatalı Kurabiye', 'categoryId': 3, 'defaultPrice': 45.0},
      {'name': 'Havuçlu Tarçınlı Kek', 'categoryId': 3, 'defaultPrice': 65.0},
      {'name': 'Milföy Hamuru', 'categoryId': 3, 'defaultPrice': 48.0},
      {'name': 'Çavdar Ekmeği', 'categoryId': 3, 'defaultPrice': 35.0},
      {'name': 'Sade Grissini', 'categoryId': 3, 'defaultPrice': 28.0},

      // 4. Et & Tavuk (categoryId: 4)
      {'name': 'Dana Kıyma (%20 Yağlı - 1 Kg)', 'categoryId': 4, 'defaultPrice': 480.0},
      {'name': 'Dana Kuşbaşı (1 Kg)', 'categoryId': 4, 'defaultPrice': 520.0},
      {'name': 'Tavuk Göğsü (Bonfile - 1 Kg)', 'categoryId': 4, 'defaultPrice': 190.0},
      {'name': 'Tavuk Baget (1 Kg)', 'categoryId': 4, 'defaultPrice': 110.0},
      {'name': 'Hazır Kasap Köfte (1 Kg)', 'categoryId': 4, 'defaultPrice': 450.0},
      {'name': 'Dana Antrikot (1 Kg)', 'categoryId': 4, 'defaultPrice': 680.0},
      {'name': 'Tavuk Kanat (1 Kg)', 'categoryId': 4, 'defaultPrice': 140.0},
      {'name': 'Kuzu Pirzola (1 Kg)', 'categoryId': 4, 'defaultPrice': 750.0},
      {'name': 'Kasap Sucuk', 'categoryId': 4, 'defaultPrice': 580.0},
      {'name': 'Macar Salam', 'categoryId': 4, 'defaultPrice': 90.0},
      {'name': 'Kokteyl Sosis', 'categoryId': 4, 'defaultPrice': 75.0},
      {'name': 'Kayseri Pastırması', 'categoryId': 4, 'defaultPrice': 1100.0},
      {'name': 'Hindi Füme', 'categoryId': 4, 'defaultPrice': 65.0},
      {'name': 'Dana Bonfile (1 Kg)', 'categoryId': 4, 'defaultPrice': 720.0},
      {'name': 'Kuzu Gerdan (1 Kg)', 'categoryId': 4, 'defaultPrice': 420.0},

      // 5. Atıştırmalık (categoryId: 5)
      {'name': 'Çikolatalı Gofret', 'categoryId': 5, 'defaultPrice': 12.0},
      {'name': 'Sade Patates Cipsi', 'categoryId': 5, 'defaultPrice': 45.0},
      {'name': 'Tuzlu Yer Fıstığı', 'categoryId': 5, 'defaultPrice': 55.0},
      {'name': 'Kavrulmuş Ay Çekirdeği', 'categoryId': 5, 'defaultPrice': 35.0},
      {'name': 'Meyveli Jelibon', 'categoryId': 5, 'defaultPrice': 28.0},
      {'name': 'Yulaflı Bisküvi', 'categoryId': 5, 'defaultPrice': 20.0},
      {'name': 'Patlamış Mısır', 'categoryId': 5, 'defaultPrice': 25.0},
      {'name': 'Sütlü Çikolata Barı', 'categoryId': 5, 'defaultPrice': 18.0},
      {'name': 'Tuzlu Kraker', 'categoryId': 5, 'defaultPrice': 15.0},
      {'name': 'Antep Fıstıklı Lokum', 'categoryId': 5, 'defaultPrice': 140.0},
      {'name': 'Çekirdeksiz Kuru Üzüm', 'categoryId': 5, 'defaultPrice': 60.0},
      {'name': 'Çiğ Badem İçi', 'categoryId': 5, 'defaultPrice': 120.0},
      {'name': 'Kremalı Gofret', 'categoryId': 5, 'defaultPrice': 22.0},
      {'name': 'Orman Meyveli Bar', 'categoryId': 5, 'defaultPrice': 24.0},
      {'name': 'Karışık Kuruyemiş', 'categoryId': 5, 'defaultPrice': 95.0},

      // 6. Temizlik (categoryId: 6)
      {'name': 'Toz Çamaşır Deterjanı', 'categoryId': 6, 'defaultPrice': 260.0},
      {'name': 'Bulaşık Makinesi Tableti', 'categoryId': 6, 'defaultPrice': 340.0},
      {'name': 'Elde Bulaşık Deterjanı (Sıvı)', 'categoryId': 6, 'defaultPrice': 65.0},
      {'name': 'Lavanta Kokulu Yüzey Temizleyici', 'categoryId': 6, 'defaultPrice': 70.0},
      {'name': 'Ultra Yoğun Çamaşır Suyu', 'categoryId': 6, 'defaultPrice': 55.0},
      {'name': 'Konsantre Çamaşır Yumuşatıcısı', 'categoryId': 6, 'defaultPrice': 95.0},
      {'name': 'Cam Temizleme Spreyi', 'categoryId': 6, 'defaultPrice': 48.0},
      {'name': 'Antibakteriyel Sıvı Sabun', 'categoryId': 6, 'defaultPrice': 50.0},
      {'name': 'Mutfak Yağ Çözücü', 'categoryId': 6, 'defaultPrice': 60.0},
      {'name': 'Banyo Kireç Çözücü', 'categoryId': 6, 'defaultPrice': 60.0},
      {'name': 'Bulaşık Süngeri (4\'lü)', 'categoryId': 6, 'defaultPrice': 30.0},
      {'name': 'Mikrofiber Temizlik Bezi', 'categoryId': 6, 'defaultPrice': 45.0},
      {'name': 'Büzgülü Çöp Poşeti', 'categoryId': 6, 'defaultPrice': 40.0},
      {'name': '2 Katlı Kağıt Havlu (6\'lı)', 'categoryId': 6, 'defaultPrice': 90.0},
      {'name': 'Parfümlü Tuvalet Kağıdı (16\'lı)', 'categoryId': 6, 'defaultPrice': 180.0},

      // 7. Diğer (categoryId: 7)
      {'name': 'Sızma Zeytinyağı (1 Lt)', 'categoryId': 7, 'defaultPrice': 310.0},
      {'name': 'Ayçiçek Yağı (5 Lt)', 'categoryId': 7, 'defaultPrice': 250.0},
      {'name': 'Toz Şeker (1 Kg)', 'categoryId': 7, 'defaultPrice': 40.0},
      {'name': 'İyotlu Sofra Tuzu', 'categoryId': 7, 'defaultPrice': 15.0},
      {'name': 'Geleneksel Türk Kahvesi', 'categoryId': 7, 'defaultPrice': 45.0},
      {'name': 'Filiz Siyah Çay (1 Kg)', 'categoryId': 7, 'defaultPrice': 180.0},
      {'name': 'Spagetti Makarna', 'categoryId': 7, 'defaultPrice': 22.0},
      {'name': 'Pilavlık Yerli Pirinç', 'categoryId': 7, 'defaultPrice': 75.0},
      {'name': 'Kırmızı Mercimek', 'categoryId': 7, 'defaultPrice': 48.0},
      {'name': 'Pilavlık Bulgur', 'categoryId': 7, 'defaultPrice': 38.0},
      {'name': 'Buğday Unu (2 Kg)', 'categoryId': 7, 'defaultPrice': 65.0},
      {'name': 'Domates Salçası', 'categoryId': 7, 'defaultPrice': 45.0},
      {'name': 'Organik Yumurta (15\'li)', 'categoryId': 7, 'defaultPrice': 75.0},
      {'name': 'Doğal Maden Suyu (6\'lı)', 'categoryId': 7, 'defaultPrice': 42.0},
      {'name': 'Pet Şişe Su (5 Lt)', 'categoryId': 7, 'defaultPrice': 30.0},
    ];

    for (var prod in products) {
      await db.insert(tableProduct, prod);
    }
  }
}
