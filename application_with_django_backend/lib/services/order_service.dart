
import '../config/api_config.dart';
import '../models/order.dart';
import 'api_services.dart';

class OrderService {
  final ApiService _apiService = ApiService();

  Future<List<Order>> getOrders() async {
    final response = await _apiService.get(ApiConfig.ordersUrl);
    return (response as List).map((json) => Order.fromJson(json)).toList();
  }

  Future<Order> getOrder(int id) async {
    final response = await _apiService.get('${ApiConfig.ordersUrl}$id/');
    return Order.fromJson(response);
  }

  Future<Order> createOrder({
    required String shippingAddress,
    required List<CartItem> cartItems,
  }) async {
    final orderData = {
      'shipping_address': shippingAddress,
      'items': cartItems.map((item) => item.toOrderItemJson()).toList(),
    };

    final response = await _apiService.post(
      ApiConfig.ordersUrl,
      orderData,
    );

    return Order.fromJson(response);
  }

  Future<Order> updateOrderStatus(int orderId, String status) async {
    final response = await _apiService.patch(
      '${ApiConfig.ordersUrl}$orderId/update_status/',
      {'status': status},
    );

    return Order.fromJson(response);
  }
}