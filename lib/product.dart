import 'dart:convert';

class Product {
  String name;
  double price;
  String imagePath;

  Product({
    required this.name,
    required this.price,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'imagePath': imagePath,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'],
      price: map['price'],
      imagePath: map['imagePath'],
    );
  }

  static String encode(List<Product> products) => json.encode(
    products.map<Map<String, dynamic>>((product) => product.toMap()).toList(),
  );

  static List<Product> decode(String products) =>
      (json.decode(products) as List<dynamic>)
          .map<Product>((item) => Product.fromMap(item))
          .toList();
}
