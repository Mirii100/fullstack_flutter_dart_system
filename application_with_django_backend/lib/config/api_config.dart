class ApiConfig {
  static const String baseUrl = 'http://127.0.0.1:8000'; // Base URL without /api
  static const String apiUrl = '$baseUrl'; // Add /api after the base URL

  // Auth endpoints
  static const String loginUrl = '$apiUrl/auth/token/';
  static const String registerUrl = '$apiUrl/users/';

  // User and Profile endpoints
  static const String userUrl = '$apiUrl/users/';
  static const String currentUserUrl = '$apiUrl/users/me/';
  static const String profileUrl = '$apiUrl/profiles/';
  static const String currentProfileUrl = '$apiUrl/profiles/me/';

  // Marketplace endpoints
  static const String categoriesUrl = '$apiUrl/categories/';
  static const String itemsUrl = '$apiUrl/items/';
  static const String myItemsUrl = '$apiUrl/items/my_items/';
  static const String searchItemsUrl = '$apiUrl/items/search/';
  static const String reviewsUrl = '$apiUrl/reviews/';
  static const String ordersUrl = '$apiUrl/orders/';
  static const String notificationsUrl = '$apiUrl/notifications/';

  // Media URLs
  static const String mediaUrl = '$baseUrl/media/';
}
