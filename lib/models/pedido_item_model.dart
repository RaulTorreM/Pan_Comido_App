import 'product_model.dart';

class PedidoItem {
  final int id;
  final int pedidoId;
  final int productoId;
  final int cantidad;
  final double precioUnitario;
  final Product? producto;

  PedidoItem({
    required this.id,
    required this.pedidoId,
    required this.productoId,
    required this.cantidad,
    required this.precioUnitario,
    this.producto,
  });

  factory PedidoItem.fromJson(Map<String, dynamic> json) {
    return PedidoItem(
      id: json['id'] ?? 0,
      pedidoId: json['pedido_id'] ?? 0,
      productoId: json['producto_id'] ?? 0,
      cantidad: json['cantidad'] ?? 0,
      precioUnitario: double.tryParse(json['precio_unitario'].toString()) ?? 0.0,
      producto: json['producto'] != null
          ? Product.fromJson(json['producto'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pedido_id': pedidoId,
        'producto_id': productoId,
        'cantidad': cantidad,
        'precio_unitario': precioUnitario,
      };
}
