class Product {
  late final String _id;
  String get id => _id;
  set id(String value) {
    _id = value;
  }

  final String title;
  final String description;

  Product({
    required this.title,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> jsonObject) {
    return Product(
      title: jsonObject['title'] as String,
      description: jsonObject['description'] as String,
    );
  }
}