import 'package:flutter/material.dart';
import '/ui/product_list_page.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Colors.brown.shade700;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        backgroundColor: color,
        title: const Text('Bakery Ecommerce'),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🧁 Imagen principal o banner
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/bakery_banner.png', 
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 25),

            Text(
              'Bienvenido a nuestra panaderia ',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Descubre los sabores tradicionales, pasteles, panes y postres hechos con amor 💛',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.brown.shade400,
              ),
            ),

            const SizedBox(height: 30),

            //  Botones estilo tarjeta
            _buildMenuCard(
              context,
              icon: Icons.cake_outlined,
              title: 'Pasteles disponibles',
              subtitle: 'Explora nuestra variedad de postres.',
              color: Colors.pink.shade100,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductListPage()),
                );
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.local_pizza_outlined,
              title: 'Pan del día',
              subtitle: 'Fresco y recién horneado cada mañana.',
              color: Colors.orange.shade100,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductListPage()),
                );
              },
            ),
            _buildMenuCard(
              context,
              icon: Icons.shopping_cart_outlined,
              title: 'Tu carrito',
              subtitle: 'Revisa tus compras antes de pagar.',
              color: Colors.yellow.shade100,
              onTap: () {
                // TODO: Navegar a página del carrito (cuando la tengas)
              },
            ),

            const SizedBox(height: 40),

            // Botón destacado
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductListPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              icon: const Icon(Icons.cookie_outlined, color: Colors.white),
              label: const Text(
                'Ver todos los productos',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tarjeta animada para cada opción del menú
  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(2, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(icon, color: Colors.brown.shade700),
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.brown.shade800,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.brown.shade500,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.brown),
          ),
        ),
      ),
    );
  }
}
