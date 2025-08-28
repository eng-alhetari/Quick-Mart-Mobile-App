import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/providers/cart_provider.dart';
import 'package:quickmart/providers/product_provider.dart';
import 'package:quickmart/routes/app_router.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartNotifierProvider);
    final products = ref.watch(productNotifierProvider); // Get the list of products

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'My Cart',
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
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
            
                // Find the corresponding product based on productName or a similar identifier
                final product = products.firstWhere(
                  (product) => product.title == item.productName,
                  orElse: () => Product(), // Return a default Product if not found
                );

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
                            item.productName,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, color: Colors.red),
                                    onPressed: () {
                                      if (item.quantity > 1) {
                                          ref.read(cartNotifierProvider.notifier)
                                              .updateCartQuantity(item.productId, item.quantity - 1);
                                      }
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(fontSize: 20, color: Colors.black),
                                  ),
                                  SizedBox(width: 10),
                                  IconButton(
                                    icon: const Icon(Icons.add, color: Colors.green), // Green plus icon
                                    onPressed: () {
                                      ref.read(cartNotifierProvider.notifier)
                                          .updateCartQuantity(item.productId, item.quantity + 1);
                                    },
                                  ),
                                ],
                              ),
                              Text(
                                'QR ${item.unitPrice.toStringAsFixed(2)}', // Display price
                                style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          ref.read(cartNotifierProvider.notifier)
                              .removeFromCart(item.productId);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
           Padding(
  padding: const EdgeInsets.all(16.0),
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green[700],
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
    ),
    onPressed: () {
      // Proceed to checkout logic
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Checkout text
        Expanded(
          child: Center(
            child: Text(
              'Go to Checkout',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // FutureBuilder to display the total price
        FutureBuilder<double>(
          future: ref.read(cartNotifierProvider.notifier).calculateTotalPrice(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Loading indicator
            } else if (snapshot.hasError) {
              return const Text(
                'Error',
                style: TextStyle(color: Colors.red),
              );
            } else {
              final totalPrice = snapshot.data ?? 0.0;
              return Container(
                decoration: BoxDecoration(
                  color: Colors.green[900],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  'QR ${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            }
          },
        ),
        SizedBox(width: 10),
      ],
    ),
  ),
),
        ],
      ),
    );
  }
}
