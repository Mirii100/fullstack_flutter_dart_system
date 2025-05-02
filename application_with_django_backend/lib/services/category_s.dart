

import '../config/api_config.dart';
import '../models/category.dart';
import 'api_services.dart';

class CategoryService {
  final ApiService _apiService = ApiService();

  Future<List<Category>> getCategories({String? search}) async {
    final response = await _apiService.get(ApiConfig.categoriesUrl);
    return (response as List).map((json) => Category.fromJson(json)).toList();
  }

  Future<Category> getCategoryById(int id) async {
    final response = await _apiService.get('${ApiConfig.categoriesUrl}$id/');
    return Category.fromJson(response);
  }
}