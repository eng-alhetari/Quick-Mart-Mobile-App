import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/repositories/product_repo.dart';

class FavoritesRepository {
  final Dio dio = Dio();
  final ProductRepository productRepo = ProductRepository();
  final String baseUrl = 'https://quickmart.codedbyyou.com/api';

  // Fetch all favorite products
   Future<List<Product>> getFavorites() async {
    try {
      // Use the enriched endpoint
      final response = await dio.get('$baseUrl/favorites?fillInProducts=true');
      
      if (response.statusCode == 200) {
        // Map the response to the Product model
        return (response.data as List).map((item) => Product.fromJson(item)).toList();
      }
      throw Exception('Failed to load favorites with details');
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      if (e.response != null) {
        print('Error response: ${e.response?.data}');
      }
      return [];
    }
  }

  // Add a product to favorites
  Future<Product> addFavorite(String productId) async {
    final response = await dio.post(
      '$baseUrl/favorites',
      data: jsonEncode({'productId': productId}),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add favorite');
    }
    return Product.fromJson(response.data);
  }

  // Remove a product from favorites
  Future<bool> removeFavorite(String productId) async {
    final response = await dio.delete('$baseUrl/favorites/$productId');
    if (response.statusCode != 204) {
      throw Exception('Failed to remove favorite');
    }
    return true;
  }
}
