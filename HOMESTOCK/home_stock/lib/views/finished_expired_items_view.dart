import 'package:flutter/material.dart';
import 'package:home_stock/database/db_helper.dart';
import 'package:home_stock/models/item_model.dart';

class BinPage extends StatefulWidget {
  final List<Item> cartItems;
  final VoidCallback onCartChanged;

  const BinPage({super.key, required this.cartItems, required this.onCartChanged});

  @override
  State<BinPage> createState() => _BinPageState();
}

class _BinPageState extends State<BinPage> {
  List<Item> expiredItems = [];
  List<Item> finishedItems = [];

  int selectedToggleIndex = 0;

  @override
  void initState() {
    super.initState();
    loadBinItems();
  }

  Future<void> loadBinItems() async {
    final allItems = await DBHelper.instance.getAllItems();

    setState(() {
      expiredItems = allItems.where((item) {
        try {
          DateTime expiry = DateTime.parse(item.expiryDate);
          return expiry.isBefore(DateTime.now()) && !item.isInCart;
        } catch (e) {
          return false;
        }
      }).toList();

      finishedItems = allItems.where((item) => item.quantity == 0 && !item.isInCart).toList();
    });
  }

  Future<void> deleteItem(Item item) async {
    final success = await DBHelper.instance.deleteItem(sno: item.serialNumber!);
    if (success) {
      setState(() {
        expiredItems.removeWhere((i) => i.serialNumber == item.serialNumber);
        finishedItems.removeWhere((i) => i.serialNumber == item.serialNumber);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item permanently deleted")),
      );
    }
  }

  void addToCart(Item item) async {
    if (!widget.cartItems.any((i) => i.serialNumber == item.serialNumber)) {
      final updatedItem = Item(
        serialNumber: item.serialNumber,
        name: item.name,
        category: item.category,
        expiryDate: item.expiryDate,
        quantity: item.quantity,
        unit: item.unit,
        isInCart: true,
      );

      final success = await DBHelper.instance.updateItem(updatedItem);

      if (success) {
        setState(() {
          widget.cartItems.add(updatedItem);

          if (selectedToggleIndex == 0) {
            expiredItems.removeWhere((i) => i.serialNumber == item.serialNumber);
          } else {
            finishedItems.removeWhere((i) => i.serialNumber == item.serialNumber);
          }
        });

        widget.onCartChanged(); // ✅ Update cart in main.dart

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${item.name} added to cart!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to add to cart")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Item> currentList = selectedToggleIndex == 0 ? expiredItems : finishedItems;

    return Scaffold(
      appBar: AppBar(title: const Text("Bin")),
      body: Column(
        children: [
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ToggleButtons(
              isSelected: [
                selectedToggleIndex == 0,
                selectedToggleIndex == 1,
              ],
              onPressed: (index) {
                setState(() {
                  selectedToggleIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(10),
              selectedColor: Colors.white,
              fillColor: selectedToggleIndex == 0 ? Colors.redAccent : Colors.orange,
              color: Colors.black,
              constraints: const BoxConstraints(minHeight: 40, minWidth: 120),
              children: const [
                Text('Expired'),
                Text('Finished'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: currentList.isEmpty
                ? Center(
                    child: Text(
                      selectedToggleIndex == 0 ? "No expired items" : "No finished items",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
                : ListView.builder(
                    itemCount: currentList.length,
                    itemBuilder: (context, index) {
                      final item = currentList[index];
                      return _buildItemCard(
                        item,
                        selectedToggleIndex == 0 ? Colors.redAccent : Colors.orange,
                      );
                    },
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
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Category: ${item.category}"),
            Text("Quantity: ${item.quantity}"),
            Text("Expires: ${item.expiryDate}"),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.cancel_outlined),
              color: Colors.redAccent,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Delete Item"),
                    content: Text("Are you sure you want to delete '${item.name}'?"),
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
                        child: const Text("Delete", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              color: Colors.green,
              onPressed: () => addToCart(item),
            ),
          ],
        ),
      ),
    );
  }
}
