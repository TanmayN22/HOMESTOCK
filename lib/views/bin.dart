import 'package:flutter/material.dart';
import 'package:homestock/database/db_helper.dart';
import 'package:homestock/models/item_model.dart';

class BinPage extends StatefulWidget {
  final List<Item> cartItems;
  final VoidCallback onCartChanged;

  const BinPage({
    super.key,
    required this.cartItems,
    required this.onCartChanged,
  });

  @override
  State<BinPage> createState() => _BinPageState();
}

class _BinPageState extends State<BinPage> {
  List<Item> expiredItems = [];
  List<Item> finishedItems = [];
  bool isLoading = false;

  int selectedToggleIndex = 0;

  @override
  void initState() {
    super.initState();
    loadBinItems();
  }

  Future<void> loadBinItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      final allItems = await DBHelper.instance.getAllItems();
      final now = DateTime.now();

      setState(() {
        expiredItems =
            allItems.where((item) {
              try {
                DateTime expiry = DateTime.parse(item.expiryDate);
                return expiry.isBefore(now) &&
                    !item.isInCart &&
                    item.quantity > 0;
              } catch (e) {
                return false;
              }
            }).toList();

        finishedItems =
            allItems.where((item) {
              return item.quantity == 0 && !item.isInCart;
            }).toList();

        isLoading = false;
      });

      debugPrint(
        "Loaded ${expiredItems.length} expired items and ${finishedItems.length} finished items",
      );
    } catch (e) {
      debugPrint("Error loading bin items: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteItem(Item item) async {
    try {
      final success = await DBHelper.instance.deleteItem(
        sno: item.serialNumber!,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${item.name} permanently deleted")),
        );
        await loadBinItems();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to delete item")));
      }
    } catch (e) {
      debugPrint("Error deleting item: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error deleting item")));
    }
  }

  Future<void> addToCart(Item item) async {
    try {
      int quantityToAdd = item.quantity > 0 ? item.quantity : 1;

      final updatedItem = item.copyWith(
        isInCart: true,
        quantity: quantityToAdd,
      );

      final success = await DBHelper.instance.updateItem(updatedItem);

      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("${item.name} added to cart!")));

        widget.onCartChanged();
        await loadBinItems();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to add to cart")));
      }
    } catch (e) {
      debugPrint("Error adding to cart: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error adding to cart")));
    }
  }

  Future<void> restoreItem(Item item) async {
    try {
      if (item.quantity == 0) {
        final controller = TextEditingController(text: "1");

        final result = await showDialog<int>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Restore Item'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Set quantity for ${item.name}:'),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      final quantity = int.tryParse(controller.text) ?? 1;
                      Navigator.pop(context, quantity);
                    },
                    child: const Text('Restore'),
                  ),
                ],
              ),
        );

        if (result != null && result > 0) {
          final updatedItem = item.copyWith(quantity: result, isInCart: false);

          final success = await DBHelper.instance.updateItem(updatedItem);
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${item.name} restored to home!")),
            );
            await loadBinItems();
          }
        }
      } else {
        final updatedItem = item.copyWith(isInCart: false);

        final success = await DBHelper.instance.updateItem(updatedItem);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${item.name} restored to home!")),
          );
          await loadBinItems();
        }
      }
    } catch (e) {
      debugPrint("Error restoring item: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error restoring item")));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Item> currentList =
        selectedToggleIndex == 0 ? expiredItems : finishedItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bin"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ToggleButtons(
              isSelected: [selectedToggleIndex == 0, selectedToggleIndex == 1],
              onPressed: (index) {
                setState(() {
                  selectedToggleIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(10),
              selectedColor: Colors.white,
              fillColor:
                  selectedToggleIndex == 0 ? Colors.redAccent : Colors.orange,
              color: Colors.black,
              constraints: const BoxConstraints(minHeight: 40, minWidth: 120),
              children: [
                Text('Expired (${expiredItems.length})'),
                Text('Finished (${finishedItems.length})'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : currentList.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            selectedToggleIndex == 0
                                ? Icons.schedule
                                : Icons.inventory_2_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            selectedToggleIndex == 0
                                ? "No expired items"
                                : "No finished items",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                    : RefreshIndicator(
                      onRefresh: loadBinItems,
                      child: ListView.builder(
                        itemCount: currentList.length,
                        itemBuilder: (context, index) {
                          final item = currentList[index];
                          return _buildItemCard(
                            item,
                            selectedToggleIndex == 0
                                ? Colors.redAccent
                                : Colors.orange,
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(Item item, Color borderColor) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: ListTile(
        leading: Icon(
          selectedToggleIndex == 0 ? Icons.schedule : Icons.inventory_2,
          color: borderColor,
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Category: ${item.category}"),
            Text("Quantity: ${item.quantity} ${item.unit}"),
            Text("Expires: ${item.expiryDate}"),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.restore),
              color: Colors.blueAccent,
              onPressed: () => restoreItem(item),
            ),
            if (item.quantity > 0 || selectedToggleIndex == 1)
              IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                color: Colors.green,
                onPressed: () => addToCart(item),
              ),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              color: Colors.redAccent,
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text("Delete Item Permanently"),
                        content: Text(
                          "Are you sure you want to permanently delete '${item.name}'? This action cannot be undone.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
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
      ),
    );
  }
}
