import 'dart:io';


import '../config/api_config.dart';
import '../models/item.dart';
import '../models/review.dart';
import 'api_services.dart';

class ItemService {
  final ApiService _apiService = ApiService();

  Future<List<Item>> getItems({
    String? search,
    int? categoryId,
    String? ordering,
  }) async {
    String url = ApiConfig.itemsUrl;
    List<String> queryParams = [];

    if (search != null && search.isNotEmpty) {
      queryParams.add('search=$search');
    }

    if (categoryId != null) {
      queryParams.add('category=$categoryId');
    }

    if (ordering != null && ordering.isNotEmpty) {
      queryParams.add('ordering=$ordering');
    }

    if (queryParams.isNotEmpty) {
      url += '?${queryParams.join('&')}';
    }

    final response = await _apiService.get(url);
    return (response as List).map((json) => Item.fromJson(json)).toList();
  }

  Future<List<Item>> getItemsByCategory(int categoryId) async {
    final response = await _apiService.get('${ApiConfig.itemsUrl}by_category/?category_id=$categoryId');
    return (response as List).map((json) => Item.fromJson(json)).toList();
  }

  Future<List<Item>> searchItems(String query) async {
    final response = await _apiService.get('${ApiConfig.searchItemsUrl}?q=$query');
    return (response as List).map((json) => Item.fromJson(json)).toList();
  }

  Future<List<Item>> getMyItems() async {
    final response = await _apiService.get(ApiConfig.myItemsUrl);
    return (response as List).map((json) => Item.fromJson(json)).toList();
  }

  Future<Item> getItem(int id) async {
    final response = await _apiService.get('${ApiConfig.itemsUrl}$id/');
    return Item.fromJson(response);
  }

  Future<Item> createItem(Item item, {File? imageFile}) async {
    final response = await _apiService.post(
      ApiConfig.itemsUrl,
      item.toJson(),
    );

    Item createdItem = Item.fromJson(response);

    // Upload image if provided
    if (imageFile != null) {
      return uploadItemImage(createdItem.id, imageFile);
    }

    return createdItem;
  }

  Future<Item> updateItem(Item item) async {
    final response = await _apiService.patch(
      '${ApiConfig.itemsUrl}${item.id}/',
      item.toJson(),
    );
    return Item.fromJson(response);
  }

  Future<Item> uploadItemImage(int itemId, File imageFile) async {
    final response = await _apiService.uploadFile(
      '${ApiConfig.itemsUrl}$itemId/',
      'image',
      imageFile,
      fields: {
        '_method': 'PATCH',
      },
    );
    return Item.fromJson(response);
  }

  Future<void> deleteItem(int id) async {
    await _apiService.delete('${ApiConfig.itemsUrl}$id/');
  }

  Future<Review> addReview(Review review) async {
    final response = await _apiService.post(
      ApiConfig.reviewsUrl,
      review.toJson(),
    );
    return Review.fromJson(response);
  }

  Future<List<Review>> getItemReviews(int itemId) async {
    final response = await _apiService.get('${ApiConfig.reviewsUrl}for_item/?item_id=$itemId');
    return (response as List).map((json) => Review.fromJson(json)).toList();
  }
}