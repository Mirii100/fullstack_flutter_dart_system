import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/category.dart';
import '../../models/item.dart';
import '../../providers/category_provider.dart';
import '../../providers/item_prov.dart';
import '../../utils/validators.dart';
import '../../widgets/item_card.dart';


class MyItemsScreen extends StatefulWidget {
  const MyItemsScreen({super.key});

  @override
  State<MyItemsScreen> createState() => _MyItemsScreenState();
}

class _MyItemsScreenState extends State<MyItemsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ItemProvider>(context, listen: false).fetchMyItems();
    Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
  }

  void _showItemForm({Item? item}) {
    showDialog(
      context: context,
      builder: (context) => ItemFormDialog(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showItemForm(),
          ),
        ],
      ),
      body: itemProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : itemProvider.myItems.isEmpty
          ? const Center(child: Text('You haven\'t listed any items yet'))
          : GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: itemProvider.myItems.length,
        itemBuilder: (context, index) {
          final item = itemProvider.myItems[index];
          return GestureDetector(
            onTap: () => _showItemForm(item: item),
            child: ItemCard(item: item),
          );
        },
      ),
    );
  }
}

class ItemFormDialog extends StatefulWidget {
  final Item? item;

  const ItemFormDialog({super.key, this.item});

  @override
  State<ItemFormDialog> createState() => _ItemFormDialogState();
}

class _ItemFormDialogState extends State<ItemFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  Category? _selectedCategory;
  bool _isAvailable = true;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _titleController.text = widget.item!.title;
      _descriptionController.text = widget.item!.description;
      _priceController.text = widget.item!.price.toString();
      _isAvailable = widget.item!.isAvailable;
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      _selectedCategory = categoryProvider.getCategoryById(widget.item!.categoryId);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final itemProvider = Provider.of<ItemProvider>(context, listen: false);
      bool success;
      if (widget.item == null) {
        // Create new item
        success = await itemProvider.createItem(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          categoryId: _selectedCategory!.id,
          price: double.parse(_priceController.text.trim()),
          imageFile: _imageFile,
        );
      } else {
        // Update existing item
        success = await itemProvider.updateItem(
          id: widget.item!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          categoryId: _selectedCategory!.id,
          price: double.parse(_priceController.text.trim()),
          isAvailable: _isAvailable,
          imageFile: _imageFile,
        );
      }
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.item == null ? 'Item created' : 'Item updated')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(itemProvider.error ?? 'Failed to save item')),
        );
      }
    } else if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
    }
  }

  Future<void> _deleteItem() async {
    if (widget.item != null) {
      final itemProvider = Provider.of<ItemProvider>(context, listen: false);
      final success = await itemProvider.deleteItem(widget.item!.id);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item deleted')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(itemProvider.error ?? 'Failed to delete item')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return AlertDialog(
      title: Text(widget.item == null ? 'Add Item' : 'Edit Item'),
      content: categoryProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: Validators.combine([
                  Validators.required('Title'),
                  Validators.maxLength('Title', 100),
                ]),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: Validators.combine([
                  Validators.required('Description'),
                  Validators.maxLength('Description', 500),
                ]),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
                hint: const Text('Select Category'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: categoryProvider.categories.isEmpty
                    ? null
                    : categoryProvider.categories
                    .map((category) => DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.name),
                ))
                    .toList(),
                onChanged: (Category? value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (Category? value) =>
                value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: Validators.combine([
                  Validators.required('Price'),
                  Validators.number('Price'),
                ]),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Available'),
                value: _isAvailable,
                onChanged: (bool value) {
                  setState(() {
                    _isAvailable = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              if (_imageFile != null) ...[
                const SizedBox(height: 16),
                Image.file(_imageFile!, height: 100, width: 100, fit: BoxFit.cover),
              ] else if (widget.item != null && widget.item!.image != null) ...[
                const SizedBox(height: 16),
                Image.network(
                  widget.item!.fullImageUrl,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        if (widget.item != null)
          TextButton(
            onPressed: _deleteItem,
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _saveItem,
          child: const Text('Save'),
        ),
      ],
    );
  }
}