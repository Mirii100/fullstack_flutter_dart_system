import 'package:application_with_django_backend/models/review.dart';

import '../config/api_config.dart';


class Item {
  final int id;
  final String title;
  final String description;
  final int categoryId;
  final String categoryName;
  final int createdById;
  final String createdByUsername;
  final double price;
  final String? image;
  final String createdAt;
  final String updatedAt;
  final bool isAvailable;
  final List<Review> reviews;
  final double averageRating;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.createdById,
    required this.createdByUsername,
    required this.price,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.isAvailable,
    required this.reviews,
    required this.averageRating,
  });

  String get fullImageUrl {
    if (image == null || image!.isEmpty) {
      return '';
    }
    return '${ApiConfig.baseUrl}$image';
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    List<Review> reviewsList = [];
    if (json['reviews'] != null) {
      reviewsList = (json['reviews'] as List)
          .map((reviewJson) => Review.fromJson(reviewJson))
          .toList();
    }

    return Item(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      categoryId: json['category'],
      categoryName: json['category_name'] ?? '',
      createdById: json['created_by'],
      createdByUsername: json['created_by_username'] ?? '',
      price: double.parse(json['price'].toString()),
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isAvailable: json['is_available'],
      reviews: reviewsList,
      averageRating: json['average_rating'] != null
          ? double.parse(json['average_rating'].toString())
          : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': categoryId,
      'price': price,
      'is_available': isAvailable,
    };
  }
}