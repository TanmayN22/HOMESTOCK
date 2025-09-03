import 'package:flutter/material.dart';
import 'package:homestock/database/db_helper.dart';
import 'package:homestock/models/item_model.dart';
import 'package:homestock/utils/themes/app_colors.dart';

class ListOfItems extends StatefulWidget {
  const ListOfItems({
    super.key,
    this.selectedCategory,
    this.searchQuery,
    this.onCartChanged,
  });

  final String? selectedCategory;
  final String? searchQuery;
  final VoidCallback? onCartChanged;

  @override
  State<ListOfItems> createState() => ListOfItemsState();
}

class ListOfItemsState extends State<ListOfItems> {
  List<Item> items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadItems(
        category: widget.selectedCategory, searchQuery: widget.searchQuery);
  }

  Future<void> loadItems({String? category, String? searchQuery}) async {
    setState(() {
      isLoading = true;
    });

    try {
      final loadedItems = await DBHelper.instance.getAllItems();
      final now = DateTime.now();

      setState(() {
        items = loadedItems.where((item) {
          if (item.isInCart) {
            return false;
          }

          DateTime expiry;
          try {
            expiry = DateTime.parse(item.expiryDate);
          } catch (e) {
            return false;
          }

          final extendedExpiry = expiry.add(const Duration(days: 1));
          bool notExpired = extendedExpiry.isAfter(now);
          bool hasQuantity = item.quantity > 0;
          bool matchesCategory = category == null || item.category == category;
          bool matchesSearch = searchQuery == null ||
              item.name.toLowerCase().contains(searchQuery.toLowerCase());

          return notExpired &&
              hasQuantity &&
              matchesCategory &&
              matchesSearch;
        }).toList();
        isLoading = false;
      });

      debugPrint("Loaded ${items.length} items for home view");
    } catch (e) {
      debugPrint("Error loading items: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateItemQuantity(Item item, int newQuantity) async {
    if (newQuantity < 0) return;

    try {
      final updatedItem = item.copyWith(quantity: newQuantity);

      final success = await DBHelper.instance.updateItem(updatedItem);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${item.name}'s quantity updated")),
        );
        await loadItems(
            category: widget.selectedCategory,
            searchQuery: widget.searchQuery);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to update quantity"),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error updating quantity: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error updating quantity"),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  Future<void> deleteItem(Item item) async {
    try {
      final success =
          await DBHelper.instance.deleteItem(sno: item.serialNumber!);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${item.name} deleted successfully")),
        );
        await loadItems(
            category: widget.selectedCategory,
            searchQuery: widget.searchQuery);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to delete item"),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error deleting item: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error deleting item"),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  Future<void> addToCart(Item item) async {
    try {
      final updatedItem = item.copyWith(isInCart: true);

      final success = await DBHelper.instance.updateItem(updatedItem);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${item.name} added to cart!")),
        );
        widget.onCartChanged?.call();
        await loadItems(
            category: widget.selectedCategory,
            searchQuery: widget.searchQuery);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to add to cart"),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error adding to cart: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error adding to cart"),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return items.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "No items found. Add some items!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              DateTime expiry;
              try {
                expiry = DateTime.parse(item.expiryDate);
              } catch (e) {
                expiry = DateTime.now().subtract(const Duration(days: 1));
              }

              int daysToExpire = expiry.difference(DateTime.now()).inDays;

              Color borderColor;
              if (daysToExpire <= 0) {
                borderColor = Colors.redAccent;
              } else if (daysToExpire <= 7) {
                borderColor = Colors.orange;
              } else if (daysToExpire <= 14) {
                borderColor = Colors.yellow;
              } else {
                borderColor = Colors.green;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor, width: 2),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.category,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                'Expires: ${item.expiryDate}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add_shopping_cart),
                              color: Colors.green,
                              onPressed: () => addToCart(item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              color: AppColors.primaryColor,
                              onPressed: () {
                                updateItemQuantity(item, item.quantity - 1);
                              },
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${item.quantity} ${item.unit}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              color: AppColors.primaryColor,
                              onPressed: () {
                                updateItemQuantity(item, item.quantity + 1);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.redAccent,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Delete Item"),
                                    content: Text(
                                        "Are you sure you want to delete '${item.name}'?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          deleteItem(item);
                                        },
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}