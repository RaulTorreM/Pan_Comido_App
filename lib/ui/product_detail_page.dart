import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final void Function(CartItem) onAddToCart;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int cantidad = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.brown.shade700,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Imagen principal
            AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: product.imageUrl ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(color: Colors.white),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 80),
              ),
            ),

            // Detalles del producto
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      5,
                      (i) {
                        double rating = product.rating ?? 0.0;
                        IconData icon;

                        if (i < rating.floor()) {
                          icon = Icons.star;
                        } else if (i < rating && rating % 1 >= 0.5) {
                          icon = Icons.star_half; 
                        } else {
                          icon = Icons.star_border; 
                        }

                        return Icon(
                          icon,
                          size: 25,
                          color: Colors.amber[600],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    'S/ ${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.brown.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.description ?? 'Sin descripción disponible.',
                    style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4),
                  ),
                  const SizedBox(height: 20),

                  // Cantidad
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (cantidad > 1) setState(() => cantidad--);
                        },
                      ),
                      Text(
                        cantidad.toString(),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setState(() => cantidad++);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Botón agregar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        widget.onAddToCart(
                          CartItem(
                            id: DateTime.now().millisecondsSinceEpoch,
                            userId: 1,
                            productoId: product.id,
                            cantidad: cantidad,
                            producto: product,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${product.name} agregado al carrito')),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Agregar al carrito'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Opiniones (ejemplo)
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                'Opiniones de clientes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.person, color: Colors.brown),
              title: Text('Muy rico el pan y buena atención.'),
              subtitle: Text('⭐️⭐️⭐️⭐️⭐️'),
            ),
            const ListTile(
              leading: Icon(Icons.person, color: Colors.brown),
              title: Text('Buena calidad, pero un poco caro.'),
              subtitle: Text('⭐️⭐️⭐️⭐️'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
