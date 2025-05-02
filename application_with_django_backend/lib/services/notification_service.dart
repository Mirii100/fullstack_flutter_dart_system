
import '../config/api_config.dart';
import '../models/notification.dart';
import 'api_services.dart';

class NotificationService {
  final ApiService _apiService = ApiService();

  Future<List<Notification>> getNotifications() async {
    final response = await _apiService.get(ApiConfig.notificationsUrl);
    return (response as List).map((json) => Notification.fromJson(json)).toList();
  }

  Future<void> markAsRead(int id) async {
    await _apiService.patch(
      '${ApiConfig.notificationsUrl}$id/mark_as_read/',
      {},
    );
  }

  Future<void> markAllAsRead() async {
    await _apiService.patch(
      '${ApiConfig.notificationsUrl}mark_all_as_read/',
      {},
    );
  }
}