import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/item_prov.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  // Helper function to normalize the image URL and avoid duplication
  String normalizeImageUrl(String? url, String baseUrl) {
    print('Category Icon URL: $url');
    if (url == null || url.isEmpty) return '';

    // Encode the URL to handle special characters (e.g., spaces)
    String encodedUrl = Uri.encodeFull(url);

    // Remove duplicate base URLs
    String cleanedUrl = encodedUrl;
    String baseUrlPattern = baseUrl;
    int baseUrlLength = baseUrl.length;

    // Keep removing duplicates until no more are found
    while (cleanedUrl.contains(baseUrlPattern + baseUrl)) {
      int firstIndex = cleanedUrl.indexOf(baseUrlPattern);
      cleanedUrl = cleanedUrl.substring(0, firstIndex) + cleanedUrl.substring(firstIndex + baseUrlLength);
    }

    // If the URL already starts with the base URL, use it as is
    if (cleanedUrl.startsWith(baseUrl)) {
      return cleanedUrl;
    }

    // If the URL is a relative path, prepend the base URL
    if (!cleanedUrl.startsWith('http') && cleanedUrl.isNotEmpty) {
      return baseUrl + (cleanedUrl.startsWith('/') ? '' : '/') + cleanedUrl;
    }

    return cleanedUrl;
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context, listen: false);
    const String baseUrl = 'http://127.0.0.1:8000';
    final String iconUrl = normalizeImageUrl(category.icon, baseUrl);

    return GestureDetector(
      onTap: () async {
        await itemProvider.fetchItemsByCategory(category.id);
        Navigator.pushNamed(context, '/items');
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 16),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconUrl.isNotEmpty && Uri.tryParse(iconUrl)?.isAbsolute == true
                  ? Image.network(
                iconUrl,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.category,
                  size: 40,
                  color: Colors.blue,
                ),
              )
                  : const Icon(
                Icons.category,
                size: 40,
                color: Colors.blue,
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}