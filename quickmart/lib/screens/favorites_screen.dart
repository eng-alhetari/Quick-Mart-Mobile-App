import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmart/providers/cart_provider.dart';
import 'package:quickmart/providers/favorites_provider.dart';
import 'package:quickmart/routes/app_router.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesNotifierProvider);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'My Favorites',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          const Divider(
            thickness: 1.0,
            color: Colors.black26,
            indent: 1.0,
            endIndent: 1.0,
          ),
          // Use Flexible or Expanded to allow the list to take available space
          Expanded(
            child: favorites.isEmpty
                ? Column(
                    children: [
                      const SizedBox(height: 16),
                      Icon(Icons.favorite, size: 150, color: Colors.black12),
                      const SizedBox(height: 10),
                      Text(
                        'No products in favorites',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Colors.black12,
                        ),
                      ),
                      const SizedBox(height: 16), // Optional space below the text
                    ],
                  )
                : ListView.builder(
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final product = favorites[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to ProductDetailScreen with the product object
                          context.pushNamed(AppRouter.product.name, extra: product);
                        },
                        child: Card(
                          color: Colors.white,
                          child: ListTile(
                            leading: Image.asset('assets/images/${product.imageName}'),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Additional Info',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'QR ${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                ref.read(favoritesNotifierProvider.notifier)
                                    .removeFavorite(product.id);
                              },
                            ),
                          ),
                        ),
                      );
                      
                    },
                  ),
          ),
          // Padding for button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: favorites.isEmpty ? Colors.grey : Colors.green[700],
                foregroundColor: favorites.isEmpty ? Colors.black38 : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 180, vertical: 25),
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: favorites.isEmpty
                  ? null // Disable button if there are no favorites
                  : () {
                      for (var product in favorites) {
                        ref.read(cartNotifierProvider.notifier).addToCart(product, 1);
                      }
                      context.pushNamed(AppRouter.cart.name);
                    },
              child: const Text('Add All To Cart'),
            ),
          ),
        ],
      ),
    );
  }
}
