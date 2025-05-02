class Review {
  final int id;
  final int itemId;
  final int userId;
  final String username;
  final int rating;
  final String comment;
  final String createdAt;

  Review({
    required this.id,
    required this.itemId,
    required this.userId,
    required this.username,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      itemId: json['item'],
      userId: json['user'],
      username: json['username'] ?? '',
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': itemId,
      'rating': rating,
      'comment': comment,
    };
  }
}