import 'package:flutter/material.dart';
import 'package:home_stock/database/db_helper.dart';
import 'package:home_stock/views/finished_expired_items_view.dart';
import 'cart_view.dart';
import 'profile_view.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/bottom_sheet_add_widget.dart';
import '../utils/app_colors.dart';

/// HomePage serves as the main screen of the app, displaying a list of stored items
/// and allowing navigation between different sections using a bottom navigation bar.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Tracks the currently selected index for bottom navigation.
  int _selectedIndex = 0;

  /// List of pages corresponding to bottom navigation items.
  final List<Widget> _pages = [
    const HomePage(), // Home view
    const Cart(), // Shopping Cart view
    const FinishedExpiredItemsView(), // Expired/Finished items view
    const Profile(), // User Profile view
  ];

  /// Stores all the items fetched from the database.
  List<Map<String, dynamic>> allItems = [];

  @override
  void initState() {
    super.initState();
    _fetchItems(); // Load items when the screen initializes
  }

  /// Fetches all items from the database and updates the state.
  void _fetchItems() async {
    debugPrint("Fetching items from database...");
    allItems = await DBHelper.instance.getAllItems();
    debugPrint("Items fetched: $allItems");
    setState(() {}); // Refresh UI with new data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'HOMESTOCK',
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
            size: 30,
          ), // Placeholder for a menu button
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          const Icon(
            Icons.circle,
            size: 30,
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: _selectedIndex == 0
          ? (allItems.isNotEmpty
              ? ListView.builder(
                  itemCount: allItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text('${index + 1}'), // Serial number
                      title: Text(allItems[index][DBHelper.COLUMN_ITEM_NAME]), // Item name
                      subtitle: Text(allItems[index][DBHelper.COLUMN_ITEM_CATEGORY]), // Category
                      trailing: SizedBox(
                        width: 96,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // add + edit button
                            IconButton(
                                onPressed: () {
                                  final selecteditem = allItems[index];
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => BottomSheetView(item: selecteditem),
                                  ).then((_) {
                                    debugPrint('fetching items');
                                    _fetchItems();
                                  });
                                },
                                icon: const Icon(Icons.edit)),
                            // delete button
                            IconButton(
                                onPressed: () async {
                                  bool check = await DBHelper.instance.deleteItem(sno: allItems[index][DBHelper.COLUMN_ITEM_SNO]);
                                  if (check) {
                                    _fetchItems();
                                  }
                                },
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : const Center(child: Text('No Items added yet'))) // Show message if no items are available
          : _pages[_selectedIndex], // Display selected page from navigation bar
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.primaryColor,
        onPressed: () async {
          // Open bottom sheet to add an item
          await showModalBottomSheet(
            context: context,
            builder: (context) => const BottomSheetView(),
          );
          _fetchItems(); // Refresh items list after adding a new item
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      /// Custom Bottom Navigation Bar for navigating between different views.
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) => setState(() => _selectedIndex = index), // Update selected index
      ),
    );
  }
}
