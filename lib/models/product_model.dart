import 'package:flutter_dotenv/flutter_dotenv.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.imageUrl,
  });

  // Convertir JSON a objeto Product
  factory Product.fromJson(Map<String, dynamic> json) {
    // obtenemos la raíz (sin /api)
    final baseUrl = (dotenv.env['BASE_URL'] ?? '').split('/api').first + '/';

    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      imageUrl: json['file_uri'] != null
          ? '$baseUrl${json['file_uri']}'
          : null,
    );
  }

  // Convertir objeto a JSON (opcional)
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category,
        'price': price,
        'imageUrl': imageUrl,
      };
}
