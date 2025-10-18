import 'pedido_item_model.dart';
import 'user_model.dart';

class Pedido {
  final int id;
  final int userId;
  final double total;
  final List<PedidoItem> items;
  final User? user;

  Pedido({
    required this.id,
    required this.userId,
    required this.total,
    required this.items,
    this.user,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List?)
            ?.map((e) => PedidoItem.fromJson(e))
            .toList() ??
        [];

    return Pedido(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      items: items,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'total': total,
        'items': items.map((e) => e.toJson()).toList(),
      };
}
