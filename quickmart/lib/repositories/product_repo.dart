import 'package:dio/dio.dart';
import 'package:quickmart/models/product.dart';

class ProductRepository {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://quickmart.codedbyyou.com/api';

  // Fetch all products
  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('$_baseUrl/products');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((productMap) => Product.fromJson(productMap))
            .toList();
      }
      throw Exception('Failed to load products');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        print('Connection error: ${e.message}');
      } else {
        print('Dio error: ${e.message}');
      }
      throw Exception('Error fetching products');
    }
  }
  // Fetch a specific product by ID
  Future<Product> getProductById(String productId) async {
    try {
      final response = await _dio.get('$_baseUrl/products/$productId');
      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      }
      throw Exception('Failed to load products');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        print('Connection error: ${e.message}');
      } else {
        print('Dio error: ${e.message}');
      }
      throw Exception('Error fetching products');
    }
  }

  // Filter products by category
  Future<List<Product>> filterProductsByCategory(String category) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/products/search',
        queryParameters: {'category': category},
      );
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((productMap) => Product.fromJson(productMap))
            .toList();
      }
      throw Exception('Failed to filter products by category');
    } on DioException catch (e) {
      print('Error filtering products by category: $e');
      return [];
    }
  }

  // Search products by name (title contains search query)
  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/products/search',
        queryParameters: {'name': query},
      );
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((productMap) => Product.fromJson(productMap))
            .toList();
      }
      throw Exception('Failed to search products');
    } on DioException catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }
}
