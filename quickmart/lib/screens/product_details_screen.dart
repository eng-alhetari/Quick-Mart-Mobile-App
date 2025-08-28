import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/providers/favorites_provider.dart';
import 'package:quickmart/providers/cart_provider.dart';
import 'package:quickmart/routes/app_router.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int quantity = 1; // Default quantity

  @override
  Widget build(BuildContext context) {
    // Watch favorite state from the provider
    final isFavorite = ref.read(favoritesNotifierProvider.notifier).isFavorite(widget.product.id);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.pop(); // Go back to the previous screen
          },
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload, color: Colors.black), // Upload icon
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.325, // Adjust to 32.5% of screen height
              width: double.infinity, // Full width
              child: ClipRRect(
                child: Image.asset(
                  'assets/images/${widget.product.imageName}',
                  fit: BoxFit.contain, // Ensures the whole image is shown inside the container
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Product Title with Favorite Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.product.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.green : Colors.grey,
                  ),
                  onPressed: () {
                    // Toggle favorite state
                    if (isFavorite) {
                      ref.read(favoritesNotifierProvider.notifier).removeFavorite(widget.product.id);
                    } else {
                      ref.read(favoritesNotifierProvider.notifier).addFavorite(widget.product.id);
                    }
                    setState(() {}); // Refresh UI
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Quantity Control Row (Minus, Quantity, Plus Icons)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.red),
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                      ),
                      SizedBox(width: 10),
                      Text(
                        '$quantity',
                        style: const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.green),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // Price Display
                Text(
                  'QR ${widget.product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(thickness: 1.0, color: Colors.black12),

            const SizedBox(height: 16),

            // Product Description Section
            const Text(
              'Product Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.description,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const Divider(thickness: 1.0, color: Colors.black12),

            const SizedBox(height: 16),

            // Reviews and Rating Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reviews',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < widget.product.rating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(), // Push the button to the bottom

            // Add to Basket Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 180, vertical: 25),
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () {
                // Add product to cart with the selected quantity
                ref.read(cartNotifierProvider.notifier).addToCart(widget.product, quantity);
                context.pushNamed(AppRouter.cart.name, queryParameters: {'quantity': '$quantity'});
              },
              child: const Text('Add To Basket'),
            ),
          ],
        ),
      ),
    );
  }
}
