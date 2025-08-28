import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/cart_item.dart';
import 'package:quickmart/repositories/cart_repo.dart';
import 'package:quickmart/models/product.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  final CartRepository _cartRepository = CartRepository();

  @override
  List<CartItem> build() {
    fetchCartItems();
    return [];
  }

  // Fetch all items in the cart
  Future<void> fetchCartItems() async {
    try {
      final cartItems = await _cartRepository.getCartItems();
      state = cartItems;
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

  // Add a product to the cart
  void addToCart(Product product, int quantity) async {
    try {
      await _cartRepository.addToCart(product.id, quantity);
      await fetchCartItems();
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  // Update cart item quantity
  Future<void> updateCartQuantity(String productId, int newQuantity) async {
    try {
      await _cartRepository.updateCartItem(productId, newQuantity);
      await fetchCartItems();
    } catch (e) {
      print('Error updating cart quantity: $e');
    }
  }

  // Remove a product from the cart
  Future<void> removeFromCart(String productId) async {
    bool isRemoved = await _cartRepository.removeCartItem(productId);
    if (isRemoved) {
      state = state.where((item) => productId != item.productId).toList();
    }
  }

  Future<double> calculateTotalPrice() async {
    return await _cartRepository.calculateTotalPrice();
  }
}

final cartNotifierProvider = NotifierProvider<CartNotifier, List<CartItem>>(
  () => CartNotifier(),
);
