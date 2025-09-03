import 'package:flutter/material.dart';
import 'package:homestock/database/db_helper.dart';
import 'package:homestock/models/item_model.dart';

class Cart extends StatefulWidget {
  final List<Item> cartItems;

  const Cart({super.key, required this.cartItems});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshCartItems();
  }

  Future<void> _refreshCartItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      final updatedCart = await DBHelper.instance.getCartItems();
      setState(() {
        widget.cartItems.clear();
        widget.cartItems.addAll(updatedCart);
        isLoading = false;
      });
      debugPrint("Cart refreshed with ${widget.cartItems.length} items");
    } catch (e) {
      debugPrint("Error refreshing cart: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

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
                try {
                  final updatedItem = item.copyWith(quantity: newQuantity);

                  final success =
                      await DBHelper.instance.updateItem(updatedItem);

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("${item.name}'s quantity updated")),
                    );
                    await _refreshCartItems();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Failed to update quantity")),
                    );
                  }
                } catch (e) {
                  debugPrint("Error updating quantity: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Error updating quantity")),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Please enter a valid quantity")),
                );
              }

              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteItem(Item item) async {
    try {
      final success =
          await DBHelper.instance.deleteItem(sno: item.serialNumber!);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("${item.name} deleted from cart and system")),
        );
        await _refreshCartItems();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to delete item")),
        );
      }
    } catch (e) {
      debugPrint("Error deleting item: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error deleting item")),
      );
    }
  }

  void _markAsBought(Item item, bool? newValue) async {
    if (newValue == true) {
      try {
        final updatedItem = item.copyWith(isInCart: false);

        final success = await DBHelper.instance.updateItem(updatedItem);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${item.name} marked as bought!")),
          );
          await _refreshCartItems();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to mark as bought")),
          );
        }
      } catch (e) {
        debugPrint("Error marking as bought: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error marking as bought")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : widget.cartItems.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Your cart is empty!",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshCartItems,
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.shopping_bag,
                              color: Colors.orange),
                          title: Text(item.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Category: ${item.category}"),
                              Text("Quantity: ${item.quantity} ${item.unit}"),
                              Text(
                                "Expires: ${item.expiryDate}",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: Colors.blueAccent,
                                onPressed: () => _editQuantity(item),
                              ),
                              Checkbox(
                                value: false,
                                onChanged: (bool? newValue) {
                                  _markAsBought(item, newValue);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: Colors.redAccent,
                                onPressed: () => showDialog(
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
                                          _deleteItem(item);
                                        },
                                        child: const Text("Delete",
                                            style:
                                                TextStyle(color: Colors.red)),
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
                ),
    );
  }
}