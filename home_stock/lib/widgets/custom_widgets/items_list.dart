import 'package:flutter/material.dart';
import 'package:home_stock/database/db_helper.dart';
import 'package:home_stock/models/item_model.dart';
import 'package:home_stock/utils/themes/app_colors.dart';

class ListOfItems extends StatefulWidget {
  const ListOfItems({super.key});

  @override
  State<ListOfItems> createState() => ListOfItemsState();
}

class ListOfItemsState extends State<ListOfItems> {
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    final loadedItems = await DBHelper.instance.getAllItems();
    setState(() {
      items = loadedItems;
    });
  }

  Future<void> updateItemQuantity(Item item, int newQuantity) async {
    if (newQuantity < 0) return; // Prevent negative values

    final updatedItem = Item(
      serialNumber: item.serialNumber,
      name: item.name,
      category: item.category,
      expiryDate: item.expiryDate,
      quantity: newQuantity,
      unit: item.unit,
    );

    final success = await DBHelper.instance.updateItem(updatedItem);
    if (success) {
      loadItems(); // Refresh list
    }
  }

  Future<void> deleteItem(Item item) async {
    final success = await DBHelper.instance.deleteItem(sno: item.serialNumber!);
    if (success) {
      setState(() {
        items.removeWhere((i) => i.serialNumber == item.serialNumber);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
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
                        // Item details
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

                        // Quantity controls
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              color: AppColors.primaryColor,
                              onPressed: () {
                                updateItemQuantity(item, item.quantity - 1);
                              },
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(),
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
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 10),

                            // Delete button
                            // IconButton(
                            //   icon: const Icon(Icons.delete_outline),
                            //   color: Colors.redAccent,
                            //   onPressed: () {
                            //     showDialog(
                            //       context: context,
                            //       builder: (context) => AlertDialog(
                            //         title: const Text("Delete Item"),
                            //         content: Text("Are you sure you want to delete '${item.name}'?"),
                            //         actions: [
                            //           TextButton(
                            //             onPressed: () => Navigator.pop(context),
                            //             child: const Text("Cancel"),
                            //           ),
                            //           TextButton(
                            //             onPressed: () {
                            //               deleteItem(item);
                            //               Navigator.pop(context);
                            //             },
                            //             child: const Text("Delete", style: TextStyle(color: Colors.red)),
                            //           ),
                            //         ],
                            //       ),
                            //     );
                            //   },
                            // ),
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
