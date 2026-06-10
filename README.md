#  Akıllı Alışveriş Listesi (Smart Shopping List)

Bu proje, **EFC304 Mobil Uygulama Tasarımı ve Geliştirme** dersi final projesi gereksinimlerine ve katı yazılım mimarisi kurallarına uygun olarak geliştirilmiş, üretim kalitesinde (production-ready) bir Flutter mobil uygulamasıdır.

Uygulama, kullanıcıların alışverişlerini planlamasını kolaylaştırmayı, harcamalarını kategorize ederek grafiklerle takip edebilmesini ve dil/tema tercihleriyle kişiselleştirilmiş bir alışveriş deneyimi yaşamasını amaçlamaktadır.

---

##  Katmanlı Mimari ve Klasör Yapısı (Layered Architecture)

Proje, bağımlılıkları minimuma indirmek ve sürdürülebilirliği artırmak adına kesin sınırlarla ayrılmış **3 Katmanlı Mimari (Presentation, Domain, Data)** yapısı üzerine kurulmuştur.

```text
lib/
├── data/                  # 1. VERİ KATMANI (DATA LAYER)
│   ├── database/          # SQLite veritabanı kurulumu (DatabaseHelper)
│   ├── models/            # Immutable veri modelleri (Category, Product, UserProfile vb.)
│   ├── dao/               # Veritabanı doğrudan erişim sınıfları (CategoryDao, ListItemDao vb.)
│   └── repositories/      # Domain katmanına veri sağlayan soyutlama katmanı (ShoppingRepository)
│
├── domain/                # 2. İŞ MANTIĞI KATMANI (DOMAIN LAYER)
│   └── state/             # State Yönetimi (ShoppingState, ThemeState, LanguageProvider)
│
└── presentation/          # 3. SUNUM KATMANI (PRESENTATION LAYER)
    ├── theme/             # Aydınlık ve Karanlık Tema tanımları (AppTheme)
    ├── widgets/           # Tekrar kullanılabilir arayüz elemanları (ShoppingListCard vb.)
    └── screens/           # Uygulama ekranları (Dashboard, Checklist, Login, Stats vb.)
```

### Katman Sorumlulukları:
1. **Data Layer (Veri Katmanı):** SQLite tablolardan veri çekme, ekleme, güncelleme işlemlerini yürütür. JSON dönüşüm metotları (`fromJson`/`toJson`) ve veri kopyalama (`copyWith`) yapıları modellerde mevcuttur.
2. **Domain Layer (İş Mantığı Katmanı):** State yönetimini barındırır. Repository katmanı ile Presentation katmanı arasında bir köprü görevi görerek arayüze veri akışını yönetir.
3. **Presentation Layer (Sunum Katmanı):** Kullanıcının etkileşime girdiği arayüzdür. İş mantığı barındırmaz, durum değişikliklerini dinleyerek arayüzü günceller.

---

##  Öne Çıkan Özellikler

*   ** Modern Giriş & Kayıt Sistemi:** Kullanıcılar hesap oluşturabilir ve yerel SQLite veritabanında şifreli olarak saklanan bilgileriyle güvenli oturum açabilir.
*   ** Kişiye Özel Kalıcı Profil:** Oturum açan kullanıcının bilgileri (Ad Soyad, E-posta vb.) yerel cihazda kalıcı olarak saklanır ve profil düzenleme dialogu üzerinden anında güncellenebilir.
*   ** Dinamik Dil Desteği (TR / EN):** Arayüzdeki tüm metinler, uyarılar, hata mesajları ve hatta veritabanından gelen kategoriler/ürünler (örn: *Meyve & Sebze* ➡️ *Fruits & Vegetables*) dil seçimine göre anlık olarak yerelleştirilir.
*   ** Detaylı Harcama Analizi:** `fl_chart` kütüphanesi kullanılarak hazırlanan Pasta (Pie) ve Çubuk (Bar) grafiklerle, kategorilere göre harcama dağılımları ve aylık harcama trendleri dinamik olarak analiz edilir.
*   ** Akıllı Kontrol Listesi (Checklist):** Ürünler kategorilerine göre gruplandırılmış olarak listelenir. Listedeki tüm ürünler işaretlendiğinde alışveriş listesi otomatik olarak "Tamamlandı" durumuna geçer.
*   ** Önerilen Ürünler:** Ürün ekleme sayfasında veritabanında önceden tanımlanmış 80'den fazla popüler market ürünü (`Domates`, `Dana Kıyma`, `Tereyağı` vb.) varsayılan fiyatlarıyla birlikte dropdown/otomatik tamamlama olarak sunulur.
*   ** Aydınlık / Karanlık Tema:** Göz yormayan, premium renk paletlerine sahip aydınlık ve karanlık tema geçişi tek tuşla yapılabilir.

---

##  Kullanılan Teknolojiler ve Bağımlılıklar

*   **Flutter & Dart**
*   **SQLite (sqflite):** İlişkisel yerel veritabanı (FOREIGN KEY ve ON DELETE CASCADE kısıtlamalarıyla).
*   **Provider:** İş mantığı ve arayüz durum yönetimi (State Management).
*   **fl_chart:** Harcama analiz grafikleri için.
*   **path_provider:** Oturum ve yerel dosya yönetimi için.

---

##  Kurulum ve Çalıştırma

Projeyi yerel bilgisayarınızda çalıştırmak için aşağıdaki adımları takip edin:

### Gereksinimler
- Bilgisayarınızda **Flutter SDK** yüklü olmalıdır.

### Adımlar

1. Depoyu bilgisayarınıza klonlayın:
   ```bash
   git clone https://github.com/cengelefe/akilli-alisveris.git
   ```
2. Proje ana dizinine gidin:
   ```bash
   cd akilli-alisveris
   ```
3. Gerekli paketleri indirin:
   ```bash
   flutter pub get
   ```
4. Uygulamayı bir emülatörde veya gerçek cihazda çalıştırın:
   ```bash
   flutter run
   ```

---

## 🔑 Varsayılan Giriş Bilgileri

Uygulamayı ilk açtığınızda test etmek için aşağıdaki varsayılan hesabı kullanabilir veya direkt **Kayıt Ol** ekranından kendi hesabınızı oluşturabilirsiniz:
-   **E-posta:** `user@smartshopping.com`
-   **Şifre:** `password123`
