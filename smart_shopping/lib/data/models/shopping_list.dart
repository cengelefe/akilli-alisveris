class ShoppingList {
  final int? id;
  final String title;
  final String date;
  final bool isCompleted;

  ShoppingList({
    this.id,
    required this.title,
    required this.date,
    this.isCompleted = false,
  });

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
      id: json['id'] as int?,
      title: json['title'] as String,
      date: json['date'] as String,
      isCompleted: (json['isCompleted'] as int) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  ShoppingList copyWith({
    int? id,
    String? title,
    String? date,
    bool? isCompleted,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
