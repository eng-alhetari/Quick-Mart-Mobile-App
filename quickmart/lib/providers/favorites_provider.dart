import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/repositories/favorite_repo.dart';

class FavoritesNotifier extends Notifier<List<Product>> {
  final FavoritesRepository _favoritesRepository = FavoritesRepository();
  // final ProductRepository _productRepository = ProductRepository();
  

  @override
  List<Product> build() {
    fetchFavorites();
    return [];
  }

  // Fetch all favorite products with full details
  Future<void> fetchFavorites() async {
    try {
      final favorites = await _favoritesRepository.getFavorites();
      state = favorites;
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }

  // Add a product to favorites
  void addFavorite(String productId) async {
    try {
      await _favoritesRepository.addFavorite(productId);
      await fetchFavorites();

    } catch (e) {
      print('Error adding to favorites: $e');
    }
  }

  // Remove a product from favorites
  Future<void> removeFavorite(String productId) async {
    bool isRemoved = await _favoritesRepository.removeFavorite(productId);
    if (isRemoved) {
      state = state.where((p) => productId != p.id).toList();
    }
  }

  // Check if a product is in the favorites list
  bool isFavorite(String productId) {
    return  state.map((product) => product.id).contains(productId);
    // return state.any((product) => product.id == productId);
  }
}

final favoritesNotifierProvider = NotifierProvider<FavoritesNotifier, List<Product>>(
  () => FavoritesNotifier(),
);
