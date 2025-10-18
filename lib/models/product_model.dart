import 'package:flutter_dotenv/flutter_dotenv.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String? imageUrl;
  final int? stock;
  final double? rating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.imageUrl,
    this.stock,
    this.rating,
  });

  /// Convertir JSON a objeto Product
  factory Product.fromJson(Map<String, dynamic> json) {
    String rawBaseUrl = dotenv.env['BASE_URL'] ?? '';
    if (rawBaseUrl.endsWith('/')) rawBaseUrl = rawBaseUrl.substring(0, rawBaseUrl.length - 1);
    if (rawBaseUrl.endsWith('/api')) {
      rawBaseUrl = rawBaseUrl.replaceFirst(RegExp(r'/api$'), '');
    }

    // Obtener ruta de imagen
    final fileUri = json['file_uri'];
    String? fullImageUrl;

    if (fileUri != null && fileUri.toString().isNotEmpty) {
      // Si ya comienza con http, usar directamente
      if (fileUri.toString().startsWith('http')) {
        fullImageUrl = fileUri;
      } else {
        fullImageUrl = '$rawBaseUrl/$fileUri';
      }
    }

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] is Map
          ? (json['category']['name'] ?? '')
          : (json['category'] ?? ''),
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      imageUrl: fullImageUrl,
      stock: json['stock'] ?? 0,
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString())
          : null,
    );
  }

  /// Convertir objeto a JSON (opcional)
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category,
        'price': price,
        'imageUrl': imageUrl,
        'stock': stock,
        'rating': rating,
      };
}
