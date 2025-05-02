import 'dart:io';
import 'package:flutter/foundation.dart';

import '../models/item.dart';
import '../models/review.dart';
import '../services/item_ser.dart';

class ItemProvider with ChangeNotifier {
  final ItemService _itemService = ItemService();

  List<Item> _items = [];
  List<Item> _myItems = [];
  Item? _selectedItem;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Item> get items => _items;
  List<Item> get myItems => _myItems;
  Item? get selectedItem => _selectedItem;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all items with optional filtering
  Future<void> fetchItems({
    String? search,
    int? categoryId,
    String? ordering,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _itemService.getItems(
        search: search,
        categoryId: categoryId,
        ordering: ordering,
      );
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching items: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch items by category
  Future<void> fetchItemsByCategory(int categoryId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _itemService.getItemsByCategory(categoryId);
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching items by category: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search items
  Future<void> searchItems(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _itemService.searchItems(query);
    } catch (e) {
      _error = e.toString();
      debugPrint('Error searching items: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch my items
  Future<void> fetchMyItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _myItems = await _itemService.getMyItems();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching my items: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get item details
  Future<void> fetchItemDetails(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedItem = await _itemService.getItem(id);
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching item details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new item
  Future<bool> createItem({
    required String title,
    required String description,
    required int categoryId,
    required double price,
    File? imageFile,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newItem = Item(
        id: 0, // Will be assigned by the server
        title: title,
        description: description,
        categoryId: categoryId,
        categoryName: '',
        createdById: 0, // Will be assigned by the server
        createdByUsername: '',
        price: price,
        image: null,
        createdAt: '',
        updatedAt: '',
        isAvailable: true,
        reviews: [],
        averageRating: 0,
      );

      await _itemService.createItem(newItem, imageFile: imageFile);
      await fetchMyItems(); // Refresh my items list
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error creating item: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update an existing item
  Future<bool> updateItem({
    required int id,
    required String title,
    required String description,
    required int categoryId,
    required double price,
    required bool isAvailable,
    File? imageFile,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // First, get the current item to preserve other fields
      Item currentItem;
      if (_selectedItem != null && _selectedItem!.id == id) {
        currentItem = _selectedItem!;
      } else {
        currentItem = await _itemService.getItem(id);
      }

      // Update fields
      final updatedItem = Item(
        id: id,
        title: title,
        description: description,
        categoryId: categoryId,
        categoryName: currentItem.categoryName,
        createdById: currentItem.createdById,
        createdByUsername: currentItem.createdByUsername,
        price: price,
        image: currentItem.image,
        createdAt: currentItem.createdAt,
        updatedAt: currentItem.updatedAt,
        isAvailable: isAvailable,
        reviews: currentItem.reviews,
        averageRating: currentItem.averageRating,
      );

      // Update the item
      Item result = await _itemService.updateItem(updatedItem);

      // Upload new image if provided
      if (imageFile != null) {
        result = await _itemService.uploadItemImage(id, imageFile);
      }

      // Update selected item
      _selectedItem = result;

      // Refresh lists
      await fetchMyItems();

      // Also update in the general items list if present
      final itemIndex = _items.indexWhere((item) => item.id == id);
      if (itemIndex != -1) {
        _items[itemIndex] = result;
      }

      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error updating item: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete an item
  Future<bool> deleteItem(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _itemService.deleteItem(id);

      // Remove from my items list
      _myItems.removeWhere((item) => item.id == id);

      // Remove from general items list if present
      _items.removeWhere((item) => item.id == id);

      // Clear selected item if it's the deleted one
      if (_selectedItem != null && _selectedItem!.id == id) {
        _selectedItem = null;
      }

      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error deleting item: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a review to an item
  Future<bool> addReview({
    required int itemId,
    required int rating,
    required String comment,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newReview = Review(
        id: 0, // Will be assigned by the server
        itemId: itemId,
        userId: 0, // Will be assigned by the server
        username: '',
        rating: rating,
        comment: comment,
        createdAt: '',
      );

      await _itemService.addReview(newReview);

      // Refresh item details to get updated reviews
      if (_selectedItem != null && _selectedItem!.id == itemId) {
        await fetchItemDetails(itemId);
      }

      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error adding review: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}