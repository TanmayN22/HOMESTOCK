import 'package:flutter/material.dart';
import 'package:homestock/database/db_helper.dart';
import 'package:homestock/models/item_model.dart';
import 'package:homestock/utils/themes/app_colors.dart';
import 'package:homestock/widgets/custom_widgets/bottom_sheet_add.dart';

class AddItemButton extends StatefulWidget {
  const AddItemButton({super.key, required this.onItemAdded});

   final VoidCallback onItemAdded;

  @override
  State<AddItemButton> createState() => _AddItemButtonState();
}

class _AddItemButtonState extends State<AddItemButton> {
  /// Stores all the items fetched from the database.
  List<Item> allItems = [];
  @override
  void initState() {
    super.initState();
    _fetchItems(); // Load items when the screen initializes
  }

  /// Fetches all items from the database and updates the state.
  void _fetchItems() async {
    debugPrint("Fetching items from database...");
    allItems = await DBHelper.instance.getAllItems();

    // Print detailed information for each item
    for (var item in allItems) {
      debugPrint('Item: ${item.serialNumber}, Name: ${item.name}, Category: ${item.category}, Quantity : ${item.quantity}');
    }

    debugPrint("Total items fetched: ${allItems.length}");
    setState(() {}); // Refresh UI with new data
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primaryColor,
      onPressed: () async {
        final result = await showModalBottomSheet(
          context: context,
          builder: (context) => const BottomSheetView(), // Your item-adding form
        );

        if (result == true) {
          widget.onItemAdded(); // Refresh items when a new item is added
        }
      },
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}