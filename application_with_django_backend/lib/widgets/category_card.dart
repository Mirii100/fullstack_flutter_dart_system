import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/item_prov.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context, listen: false);

    // Helper function to safely parse the icon value
    IconData _getIcon() {
      try {
        // Try parsing the icon string to an integer and return the icon
        return category.icon.isNotEmpty
            ? IconData(int.parse(category.icon), fontFamily: 'MaterialIcons')
            : Icons.category;
      } catch (e) {
        // If an error occurs during parsing, return the default icon
        print("Error parsing icon: $e");
        return Icons.category;
      }
    }

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
              Icon(
                _getIcon(),
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
