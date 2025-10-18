import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final VoidCallback onClearCart;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onClearCart,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double get total => widget.cartItems.fold(
        0.0,
        (sum, item) => sum + (item.producto?.price ?? 0) * item.cantidad,
      );

  void _removeItem(CartItem item) {
    setState(() {
      widget.cartItems.remove(item);
    });
  }

  void _increaseQty(CartItem item) {
    setState(() {
      item.cantidad++;
    });
  }

  void _decreaseQty(CartItem item) {
    setState(() {
      if (item.cantidad > 1) item.cantidad--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Tu Carrito'),
        backgroundColor: Colors.brown.shade700,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.white,size: 25,),
            tooltip: 'Vaciar carrito',
            onPressed: widget.cartItems.isEmpty
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Vaciar carrito'),
                        content: const Text(
                            '¿Seguro que deseas eliminar todos los productos?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade700),
                            onPressed: () {
                              widget.onClearCart();
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: const Text('Vaciar'),
                          ),
                        ],
                      ),
                    );
                  },
          ),
        ],
      ),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text('Tu carrito está vacío'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                final product = item.producto ??
                    Product(
                      id: 0,
                      name: 'Producto',
                      description: '',
                      category: '',
                      price: 0,
                    );

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: product.imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: product.imageUrl!,
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                              memCacheHeight: 300,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.white,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              ),
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            ),
                    ),
                    title: Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'S/ ${(product.price * item.cantidad).toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.brown.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => _decreaseQty(item),
                              icon: const Icon(Icons.remove_circle_outline),
                              color: Colors.brown,
                            ),
                            Text(
                              '${item.cantidad}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              onPressed: () => _increaseQty(item),
                              icon: const Icon(Icons.add_circle_outline),
                              color: Colors.brown,
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      color: Colors.red.shade400,
                      onPressed: () => _removeItem(item),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: widget.cartItems.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'S/ ${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.payment),
                      label: const Text('Realizar pedido'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown.shade700,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pedido realizado (demo)'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
