import 'product_model.dart';

class CartItem {
  final int id;
  final int userId;
  final int productoId;
  int cantidad;
  final Product? producto;

  CartItem({
    required this.id,
    required this.userId,
    required this.productoId,
    this.cantidad=1,
    this.producto,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      productoId: json['producto_id'] ?? 0,
      cantidad: json['cantidad'] ?? 1,
      producto: json['producto'] != null
          ? Product.fromJson(json['producto'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'producto_id': productoId,
        'cantidad': cantidad,
      };
}
