import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ExpansionTile(
        title: Text(
          'Order #${order.id}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${order.status.toUpperCase()} - \$${order.totalAmount.toStringAsFixed(2)}',
          style: TextStyle(
            color: order.status == 'delivered' ? Colors.green : Colors.orange,
            fontSize: 14,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Placed on: ${DateFormat('MMM d, yyyy').format(DateTime.parse(order.createdAt))}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Shipping Address: ${order.shippingAddress}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Items:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...order.items.map((item) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: Text(
                    item.itemTitle,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    '\$${item.price.toStringAsFixed(2)} x ${item.quantity}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Text(
                    '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
                const SizedBox(height: 16),
                Text(
                  'Total: \$${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}