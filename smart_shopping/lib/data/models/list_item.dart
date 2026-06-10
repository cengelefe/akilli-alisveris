class ListItem {
  final int? id;
  final int listId;
  final int productId;
  final double price;
  final int quantity;
  final bool isChecked;

  ListItem({
    this.id,
    required this.listId,
    required this.productId,
    this.price = 0.0,
    this.quantity = 1,
    this.isChecked = false,
  });

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
      id: json['id'] as int?,
      listId: json['listId'] as int,
      productId: json['productId'] as int,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      isChecked: (json['isChecked'] as int) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listId': listId,
      'productId': productId,
      'price': price,
      'quantity': quantity,
      'isChecked': isChecked ? 1 : 0,
    };
  }

  ListItem copyWith({
    int? id,
    int? listId,
    int? productId,
    double? price,
    int? quantity,
    bool? isChecked,
  }) {
    return ListItem(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      productId: productId ?? this.productId,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
