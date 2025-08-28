import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:quickmart/models/cart_item.dart';

class CartRepository {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://quickmart.codedbyyou.com/api';


  // Fetch all items in the cart
  Future<List<CartItem>> getCartItems() async {
    // Fetch cart items with filled-in product details
    final response = await _dio.get('$_baseUrl/cart?fillInProducts=true');
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((item) => CartItem.fromJson(item))
          .toList();
    }
    throw Exception('Failed to load cart items');
  }

  // Add a product to the cart
  Future<CartItem> addToCart(String productId, int quantity) async {
    final response = await _dio.post(
      '$_baseUrl/cart',
      data: jsonEncode({'productId': productId, 'quantity': quantity}),
      options: Options(headers: {'Content-Type': 'application/json'}),
      // data: {'productId': productId, 'quantity': quantity},
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add cart item');
    }
    return CartItem.fromJson(response.data);
  }

  // Update the quantity of a cart item
  Future<CartItem> updateCartItem(String productId, int quantity) async {
    final response = await _dio.put(
      '$_baseUrl/cart/$productId',
      data: jsonEncode({'quantity': quantity}),
      options: Options(headers: {'Content-Type': 'application/json'}),
      // data: {'productId': productId, 'quantity': quantity},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update cart item');
    }
    return CartItem.fromJson(response.data);
  }

  // Remove a product from the cart
  Future<bool> removeCartItem(String productId) async {
    final response = await _dio.delete('$_baseUrl/cart/$productId');
    if (response.statusCode != 204) {
      throw Exception('Failed to remove cart item');
    }
    return true;
  }

  // Remove all items from the cart
  Future<bool> removeAllCartItems() async {
    final response = await _dio.delete('$_baseUrl/cart');
    if (response.statusCode != 204) {
      throw Exception('Failed to remove cart item');
    }
    return true;
  }

  // Calculate the total price of items in the cart
  Future<double> calculateTotalPrice() async {
    final cartItems = await getCartItems();
    if (cartItems.isEmpty) return 0.0;
    return cartItems
        .map((item) => item.unitPrice * item.quantity)
        .reduce((total, price) => total + price);
  }


}
