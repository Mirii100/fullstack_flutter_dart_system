import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/item.dart';
import '../providers/order_provider.dart';


class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(12)),
              child: item.fullImageUrl.isNotEmpty
                  ? Image.network(
                item.fullImageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 50),
              )
                  : const Icon(Icons.image_not_supported, size: 50),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14, color: Colors.green),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    Text(
                      item.averageRating.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      cartProvider.isInCart(item.id)
                          ? Icons.shopping_cart
                          : Icons.add_shopping_cart,
                      color: cartProvider.isInCart(item.id)
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    onPressed: () {
                      cartProvider.addItem(item);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item.title} added to cart')),
                      );
                    },
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