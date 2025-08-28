import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/repositories/category_repo.dart';

class CategorytNotifier extends Notifier<List<String>> {
  final CategoryRepository _categoryRepository = CategoryRepository();

  @override
  List<String> build() {
    fetchCategories();
    return [];
  }

  // Fetch all products
  Future<void> fetchCategories() async {
    try {
      List<String> categories = await _categoryRepository.getCategories();
      state = categories;
    } catch (e) {
      print('Error fetching products: $e');
    }
  }
}


final categoryNotifierProvider = NotifierProvider<CategorytNotifier, List<String>>(
  () => CategorytNotifier(),
);
