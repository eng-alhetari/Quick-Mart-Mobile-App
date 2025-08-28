import 'package:dio/dio.dart';

class CategoryRepository {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://quickmart.codedbyyou.com/api';

  // Fetch all categories
  Future<List<String>> getCategories() async {
    final response = await _dio.get('$_baseUrl/categories');
    if (response.statusCode == 200) {
      return List<String>.from(response.data); // Parse the list of category names
    }
    throw Exception('Failed to load categories');
  }
}
