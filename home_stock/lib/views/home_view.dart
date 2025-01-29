import 'package:flutter/material.dart';
import 'package:home_stock/database/db_helper.dart';
import 'package:home_stock/widgets/appbar.dart';
import 'package:home_stock/widgets/custom_shapes/primary_header_container.dart';
import '../widgets/bottom_sheet_add_widget.dart';
import '../utils/themes/app_colors.dart';
import '../models/item_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      debugPrint('Item: ${item.serialNumber}, Name: ${item.name}, Category: ${item.category}');
    }

    debugPrint("Total items fetched: ${allItems.length}");
    setState(() {}); // Refresh UI with new data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SingleChildScrollView(
        child: Column(
          children: [
            PrimaryHeaderContainer(
                child: Column(
              children: [
                CustomAppbar(
                  title: Text('HOMESTOCK'),
                )
              ],
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            builder: (context) => const BottomSheetView(),
          );
          _fetchItems();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
