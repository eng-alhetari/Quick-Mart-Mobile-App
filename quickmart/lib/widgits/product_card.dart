import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/providers/cart_provider.dart';
import 'package:quickmart/routes/app_router.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      clipBehavior: Clip.antiAlias, // Ensures the content inside respects rounded corners
      elevation: 5,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20), // Ensure image respects rounded corners
            child: Image.asset('assets/images/${product.imageName}'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              product.title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              product.category,
              style: const TextStyle(fontSize: 17, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'QR ${product.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.green, // Green background color
                  shape: BoxShape.rectangle, // Circular shape
                  borderRadius: BorderRadius.circular(5), // Rounded edges
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white, // White icon color
                    size: 16, // Adjust icon size to fit within 20x20
                  ),
                  padding: EdgeInsets.zero, // Remove padding to fit icon perfectly
                  constraints: BoxConstraints(), // Remove constraints for fitting
                  onPressed: () {
                    ref.read(cartNotifierProvider.notifier).addToCart(product, 1);
                    context.pushNamed(AppRouter.cart.name);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}