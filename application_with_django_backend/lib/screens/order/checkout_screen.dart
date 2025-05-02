import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../providers/order_provider.dart';
import '../../services/order_service.dart';
import '../../utils/validators.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shippingAddressController = TextEditingController();

  @override
  void dispose() {
    _shippingAddressController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (_formKey.currentState!.validate()) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final orderService = OrderService();
      try {
        await orderService.createOrder(
          shippingAddress: _shippingAddressController.text.trim(),
          cartItems: cartProvider.cartItems,
        );
        cartProvider.clearCart();
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/order_history',
              (route) => route.isFirst,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place order: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order Summary',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...cartProvider.cartItems.map((cartItem) => ListTile(
                title: Text(cartItem.itemTitle),
                subtitle: Text(
                  '\$${cartItem.price.toStringAsFixed(2)} x ${cartItem.quantity}',
                ),
                trailing: Text(
                  '\$${cartItem.total.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
              const SizedBox(height: 16),
              Text(
                'Total: \$${cartProvider.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Text(
                'Shipping Address',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _shippingAddressController,
                decoration: const InputDecoration(
                  labelText: 'Shipping Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: Validators.required('Shipping Address'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _placeOrder,
                child: const Text('Place Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}