import 'package:flutter/material.dart';
import 'package:home_stock/database/db_helper.dart';
import 'package:home_stock/models/item_model.dart';

class Cart extends StatefulWidget {
  final List<Item> cartItems;

  const Cart({super.key, required this.cartItems});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  // Refresh UI after operations
  Future<void> _refreshCartItems() async {
    final updatedCart = await DBHelper.instance.getCartItems();
    setState(() {
      widget.cartItems.clear();
      widget.cartItems.addAll(updatedCart);
    });
  }

  // ✅ Edit Quantity Function
  void _editQuantity(Item item) async {
    final controller = TextEditingController(text: item.quantity.toString());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Quantity'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Quantity'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final int? newQuantity = int.tryParse(controller.text);

              if (newQuantity != null && newQuantity >= 0) {
                final updatedItem = Item(
                  serialNumber: item.serialNumber,
                  name: item.name,
                  category: item.category,
                  expiryDate: item.expiryDate,
                  quantity: newQuantity,
                  unit: item.unit,
                  isInCart: item.isInCart,
                );

                final success = await DBHelper.instance.updateItem(updatedItem);

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${item.name}'s quantity updated")),
                  );
                  await _refreshCartItems();
                }
              }

              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // ✅ Delete Item Completely
  void _deleteItem(Item item) async {
    final success = await DBHelper.instance.deleteItem(sno: item.serialNumber!);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${item.name} deleted from cart and system")),
      );
      await _refreshCartItems();
    }
  }

  // ✅ Mark as Bought: Pop from cart and add back to home item list
  void _markAsBought(Item item) async {
    final updatedItem = Item(
      serialNumber: item.serialNumber,
      name: item.name,
      category: item.category,
      expiryDate: item.expiryDate,
      quantity: item.quantity,
      unit: item.unit,
      isInCart: false, // ✅ Move back to the home list!
    );

    final success = await DBHelper.instance.updateItem(updatedItem);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${item.name} marked as bought!")),
      );
      await _refreshCartItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shopping Cart")),
      body: widget.cartItems.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.shopping_bag),
                    title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Category: ${item.category}"),
                        Text("Quantity: ${item.quantity} ${item.unit}"),
                        // ✅ Removed expiry display!
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ✅ Edit quantity
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.blueAccent,
                          onPressed: () => _editQuantity(item),
                        ),

                        // ✅ Mark as bought (checkbox)
                        IconButton(
                          icon: const Icon(Icons.check_box),
                          color: Colors.green,
                          onPressed: () => _markAsBought(item),
                        ),

                        // ✅ Delete item
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.redAccent,
                          onPressed: () => showDialog(
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
                                    _deleteItem(item);
                                  },
                                  child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
