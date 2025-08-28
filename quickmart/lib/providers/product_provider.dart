import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/repositories/product_repo.dart';

class ProductNotifier extends Notifier<List<Product>> {
  final ProductRepository _productRepository = ProductRepository();

  @override
  List<Product> build() {
    fetchProducts();
    return [];
  }

  // Fetch all products
  Future<void> fetchProducts() async {
    try {
      List<Product> products = await _productRepository.getProducts();
      state = products;
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  // Filter products by category
  Future<void> filterProductsByCategory(String category) async {
    try {
      List<Product> filteredProducts = await _productRepository.filterProductsByCategory(category);
      state = filteredProducts;
    } catch (e) {
      print('Error filtering products by category: $e');
    }
  }

  // Search products by title
  Future<void> searchProducts(String query) async {
    try {
      List<Product> searchedProducts = await _productRepository.searchProducts(query);
      state = searchedProducts;
    } catch (e) {
      print('Error searching products: $e');
    }
  }
}


final productNotifierProvider = NotifierProvider<ProductNotifier, List<Product>>(
  () => ProductNotifier(),
);
