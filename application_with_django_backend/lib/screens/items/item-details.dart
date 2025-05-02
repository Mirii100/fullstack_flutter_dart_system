import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/item_prov.dart';
import '../../providers/order_provider.dart';
import '../../widgets/review_card.dart';


class ItemDetailScreen extends StatefulWidget {
  final int itemId;

  const ItemDetailScreen({super.key, required this.itemId});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final _reviewCommentController = TextEditingController();
  int _rating = 1;

  @override
  void initState() {
    super.initState();
    Provider.of<ItemProvider>(context, listen: false).fetchItemDetails(widget.itemId);
  }

  @override
  void dispose() {
    _reviewCommentController.dispose();
    super.dispose();
  }

  Future<void> _addReview(ItemProvider itemProvider) async {
    final success = await itemProvider.addReview(
      itemId: widget.itemId,
      rating: _rating,
      comment: _reviewCommentController.text.trim(),
    );
    if (success) {
      _reviewCommentController.clear();
      setState(() {
        _rating = 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review added successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(itemProvider.error ?? 'Failed to add review')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final item = itemProvider.selectedItem;

    return Scaffold(
      appBar: AppBar(
        title: Text(item?.title ?? 'Item Details'),
      ),
      body: itemProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : item == null
          ? const Center(child: Text('Item not found'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.fullImageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.fullImageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 100),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              item.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${item.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                Text(
                  item.averageRating.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                Text('(${item.reviews.length} reviews)'),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              item.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Category: ${item.categoryName}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Seller: ${item.createdByUsername}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: item.isAvailable
                  ? () {
                cartProvider.addItem(item);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.title} added to cart')),
                );
              }
                  : null,
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add to Cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: item.isAvailable ? Colors.blue : Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Reviews',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            item.reviews.isEmpty
                ? const Text('No reviews yet')
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: item.reviews.length,
              itemBuilder: (context, index) {
                return ReviewCard(review: item.reviews[index]);
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Add a Review',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<int>(
              value: _rating,
              items: List.generate(5, (index) => index + 1)
                  .map((rating) => DropdownMenuItem(
                value: rating,
                child: Text('$rating Star${rating > 1 ? 's' : ''}'),
              ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _rating = value;
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reviewCommentController,
              decoration: const InputDecoration(
                labelText: 'Your Review',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _addReview(itemProvider),
              child: const Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}