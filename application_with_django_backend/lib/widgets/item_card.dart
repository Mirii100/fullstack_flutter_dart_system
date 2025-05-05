import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item.dart';
import '../providers/order_provider.dart';

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({super.key, required this.item});

  // Helper function to normalize the image URL and avoid duplication
  String normalizeImageUrl(String? url, String baseUrl) {
    // Log the URL for debugging
    print('Original Image URL: $url');

    // Handle null or empty URL
    if (url == null || url.isEmpty) {
      return '';
    }

    // Encode the URL to handle special characters
    String encodedUrl = Uri.encodeFull(url);

    // Remove duplicate base URLs
    String cleanedUrl = encodedUrl;
    String baseUrlPattern = baseUrl;

    // Split the URL by the base URL to count occurrences
    List<String> parts = cleanedUrl.split(baseUrlPattern);
    if (parts.length > 2) {
      // If there are duplicates, keep only the first occurrence of baseUrl
      cleanedUrl = baseUrlPattern + parts.sublist(1).join('');
    } else {
      cleanedUrl = encodedUrl;
    }

    // If the URL is a relative path, prepend the base URL
    if (!cleanedUrl.startsWith('http') && cleanedUrl.isNotEmpty) {
      return baseUrl + (cleanedUrl.startsWith('/') ? '' : '/') + cleanedUrl;
    }

    return cleanedUrl; // Return the encoded URL if already valid
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    // Define the base URL for your server
    const String baseUrl = 'http://127.0.0.1:8000';
    // Normalize the image URL
    final String imageUrl = normalizeImageUrl(item.fullImageUrl, baseUrl);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: imageUrl.isNotEmpty && Uri.tryParse(imageUrl)?.isAbsolute == true
                  ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                headers: const {'Authorization': 'Bearer YOUR_TOKEN_HERE'}, // Replace with actual token
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