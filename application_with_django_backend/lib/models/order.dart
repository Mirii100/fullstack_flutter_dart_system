class Order {
  final int id;
  final int userId;
  final String username;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String shippingAddress;
  final double totalAmount;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.userId,
    required this.username,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.shippingAddress,
    required this.totalAmount,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<OrderItem> orderItems = [];
    if (json['items'] != null) {
      orderItems = (json['items'] as List)
          .map((itemJson) => OrderItem.fromJson(itemJson))
          .toList();
    }

    return Order(
      id: json['id'],
      userId: json['user'],
      username: json['username'] ?? '',
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      shippingAddress: json['shipping_address'],
      totalAmount: double.parse(json['total_amount'].toString()),
      items: orderItems,
    );
  }
}

class OrderItem {
  final int id;
  final int itemId;
  final String itemTitle;
  final int quantity;
  final double price;

  OrderItem({
    required this.id,
    required this.itemId,
    required this.itemTitle,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      itemId: json['item'],
      itemTitle: json['item_title'] ?? '',
      quantity: json['quantity'],
      price: double.parse(json['price'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'quantity': quantity,
    };
  }
}

class CartItem {
  final int itemId;
  final String itemTitle;
  final double price;
  final String? image;
  int quantity;

  CartItem({
    required this.itemId,
    required this.itemTitle,
    required this.price,
    this.image,
    this.quantity = 1,
  });

  double get total => price * quantity;

  Map<String, dynamic> toOrderItemJson() {
    return {
      'item_id': itemId,
      'quantity': quantity,
    };
  }
}