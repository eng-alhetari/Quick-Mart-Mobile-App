import 'package:go_router/go_router.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/screens/cart_screen.dart';
import 'package:quickmart/screens/favorites_screen.dart';
import 'package:quickmart/screens/product_details_screen.dart';
import 'package:quickmart/screens/product_screen.dart';
import 'package:quickmart/screens/shell_screen.dart';

class AppRouter {
  static const shop = (name: 'shop', path: '/');
  static const cart = (name: 'cart', path: '/cart');
  static const favorites = (name: 'favorites', path: '/favorites');
  static const product = (name: 'product', path: '/product'); // No ID in the path

  static final router = GoRouter(
    initialLocation: shop.path,
    routes: [
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
            name: shop.name,
            path: shop.path,
            builder: (context, state) =>
                const ProductListScreen(),
            routes: [
              GoRoute(
                name: cart.name,
                path: cart.path,
                builder: (context, state) => const CartScreen(),
              ),
              GoRoute(
                name: favorites.name,
                path: favorites.path,
                builder: (context, state) =>
                    const FavoritesScreen(),
              ),
              GoRoute(
                name: product.name,
                path: product.path, // No ID required
                builder: (context, state) {
                  // Retrieve the product from the `extra` parameter
                  final product = state.extra as Product;
                  return ProductDetailScreen(product: product);
                },
              ),
            ],
          ),
        ],
      ),
    ]
  );
}
