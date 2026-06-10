class Product {
  final int? id;
  final String name;
  final int categoryId;
  final double defaultPrice;

  Product({
    this.id,
    required this.name,
    required this.categoryId,
    this.defaultPrice = 0.0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      name: json['name'] as String,
      categoryId: json['categoryId'] as int,
      defaultPrice: (json['defaultPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'defaultPrice': defaultPrice,
    };
  }

  Product copyWith({
    int? id,
    String? name,
    int? categoryId,
    double? defaultPrice,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      defaultPrice: defaultPrice ?? this.defaultPrice,
    );
  }
}
