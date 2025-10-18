import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';
import '../models/cart_item_model.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductService _productService = ProductService();
  late Future<List<Product>> _futureProducts;
  final List<CartItem> _cartItems = [];


  @override
  void initState() {
    super.initState();
    _futureProducts = _productService.getProducts();
  }

  Future<void> _refreshProducts() async {
    final newProducts = _productService.getProducts();
    setState(() {
      _futureProducts = newProducts;
    });
    await newProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Productos'),
        backgroundColor: Colors.brown.shade700,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white,size: 25,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartPage(
                    cartItems: _cartItems,
                    onClearCart: () {
                      setState(() => _cartItems.clear());
                    },
                  ),
                ),
              );
            },
          ),
        ],

      ),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.brown),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return const Center(child: Text('No hay productos disponibles.'));
          }

          return RefreshIndicator(
            color: Colors.brown,
            onRefresh: _refreshProducts,
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.68,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onAddToCart: () {
                    setState(() {
                      _cartItems.add(
                        CartItem(
                          id: DateTime.now().millisecondsSinceEpoch,
                          userId: 1, // luego lo tomaremos del usuario logueado
                          productoId: product.id,
                          cantidad: 1,
                          producto: product,
                        ),
                      );
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} agregado al carrito'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  onViewDetail: (selectedProduct) { 
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(
                          product: selectedProduct,
                          onAddToCart: (item) {
                            final existing = _cartItems.indexWhere((i) => i.productoId == item.productoId);
                            if (existing >= 0) {
                              setState(() {
                                _cartItems[existing].cantidad += item.cantidad;
                              });
                            } else {
                              setState(() {
                                _cartItems.add(item);
                              });
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${selectedProduct.name} agregado al carrito')),
                            );
                          },
                        ),
                      ),
                    );
                  },

                );
              },
            ),
          );
        },
      ),
    );
  }
}

// --- COMPONENTE REUTILIZABLE: TARJETA DE PRODUCTO ---
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final Function(Product) onViewDetail;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => onViewDetail(product),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: product.imageUrl ?? '',
                fit: BoxFit.cover,
                memCacheHeight: 500,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(color: Colors.white),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image, color: Colors.grey, size: 60),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'S/ ${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.brown.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
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
                          size: 18,
                          color: Colors.amber[600],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: onAddToCart,
                    icon: const Icon(Icons.add_shopping_cart, size: 18),
                    label: const Text('Agregar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade700,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(38),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
