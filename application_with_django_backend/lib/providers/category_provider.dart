import 'package:flutter/foundation.dart';

import '../models/category.dart' as app;
import '../services/category_s.dart';


class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  List<app.Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<app.Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCategories({String? search}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _categoryService.getCategories(search: search);
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching categories: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  app.Category? getCategoryById(int id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }
}