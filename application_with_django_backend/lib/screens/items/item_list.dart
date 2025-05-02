import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/item_prov.dart';
import '../../widgets/item_card.dart';


class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final _searchController = TextEditingController();
  String? _ordering;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Items'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Items',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          itemProvider.searchItems(_searchController.text.trim());
                        },
                      ),
                    ),
                    onSubmitted: (value) {
                      itemProvider.searchItems(value.trim());
                    },
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  hint: const Text('Sort'),
                  value: _ordering,
                  items: const [
                    DropdownMenuItem(value: 'created_at', child: Text('Newest')),
                    DropdownMenuItem(value: '-created_at', child: Text('Oldest')),
                    DropdownMenuItem(value: 'price', child: Text('Price: Low to High')),
                    DropdownMenuItem(value: '-price', child: Text('Price: High to Low')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _ordering = value;
                    });
                    itemProvider.fetchItems(ordering: value);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: itemProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : itemProvider.items.isEmpty
                ? const Center(child: Text('No items found'))
                : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: itemProvider.items.length,
              itemBuilder: (context, index) {
                final item = itemProvider.items[index];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/item_detail',
                    arguments: item.id,
                  ),
                  child: ItemCard(item: item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}