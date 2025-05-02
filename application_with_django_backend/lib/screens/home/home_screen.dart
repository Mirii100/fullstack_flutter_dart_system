import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_providers.dart';
import '../../providers/category_provider.dart';
import '../../providers/item_prov.dart';
import '../../widgets/category_card.dart';
import '../../widgets/item_card.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    Provider.of<ItemProvider>(context, listen: false).fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final itemProvider = Provider.of<ItemProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => Navigator.pushNamed(context, '/my_items'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Categories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              categoryProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : categoryProvider.categories.isEmpty
                  ? const Text('No categories found')
                  : SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryProvider.categories[index];
                    return CategoryCard(category: category);
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Featured Items',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              itemProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : itemProvider.items.isEmpty
                  ? const Text('No items found')
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: itemProvider.items.length,
                itemBuilder: (context, index) {
                  final item = itemProvider.items[index];
                  return ItemCard(item: item);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}