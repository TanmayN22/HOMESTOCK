import 'package:flutter/material.dart';
import 'package:home_stock/database/db_helper.dart';
import '../widgets/bottom_sheet_add_widget.dart';
import '../utils/app_colors.dart';
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('HOMESTOCK'),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu, size: 30),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, size: 30),
          ),
          const SizedBox(width: 5),
          const Icon(Icons.circle, size: 30),
          const SizedBox(width: 15)
        ],
      ),
      body: allItems.isNotEmpty
          ? ListView.builder(
              itemCount: allItems.length,
              itemBuilder: (context, index) {
                final item = allItems[index];
                return ListTile(
                  leading: Text('${index + 1}'),
                  title: Text(item.name),
                  subtitle: Text(item.category),
                  trailing: SizedBox(
                    width: 96,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => BottomSheetView(item: item),
                            ).then((_) {
                              debugPrint('Fetching items');
                              _fetchItems();
                            });
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () async {
                            bool check = await DBHelper.instance.deleteItem(
                              sno: item.serialNumber!,
                            );
                            if (check) {
                              _fetchItems();
                            }
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(child: Text('No Items added yet')),
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
