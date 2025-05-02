import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/order_provider.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: cartProvider.cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartProvider.cartItems[index];
                return Card(
                  child: ListTile(
                    leading: cartItem.image != null && cartItem.image!.isNotEmpty
                        ? Image.network(
                      '${cartItem.image}',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                    )
                        : const Icon(Icons.image_not_supported),
                    title: Text(cartItem.itemTitle),
                    subtitle: Text(
                      '\$${cartItem.price.toStringAsFixed(2)} x ${cartItem.quantity} = \$${cartItem.total.toStringAsFixed(2)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => cartProvider.decrementItem(cartItem.itemId),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => cartProvider.incrementItem(cartItem.itemId),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => cartProvider.removeItem(cartItem.itemId),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total: \$${cartProvider.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/checkout'),
                  child: const Text('Proceed to Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}