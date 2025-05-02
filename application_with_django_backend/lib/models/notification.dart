class Notification {
  final int id;
  final int userId;
  final String title;
  final String message;
  final bool isRead;
  final String createdAt;

  Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      userId: json['user'],
      title: json['title'],
      message: json['message'],
      isRead: json['is_read'],
      createdAt: json['created_at'],
    );
  }
}