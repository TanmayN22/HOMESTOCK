import 'package:flutter/material.dart';
import 'package:home_stock/utils/constants/sizes.dart';
import 'package:home_stock/widgets/custom_shapes/primary_header_container.dart';
import 'package:home_stock/widgets/custom_widgets/add_item_widget.dart';
import 'package:home_stock/widgets/custom_widgets/body_header_section.dart';
import 'package:home_stock/widgets/custom_widgets/home_appbar.dart';
import 'package:home_stock/widgets/custom_widgets/home_category_section.dart';
import 'package:home_stock/widgets/custom_widgets/items_list.dart';
import 'package:home_stock/widgets/custom_widgets/search_container_widget.dart';
import 'package:home_stock/utils/constants/categories.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> categories = CategoryConstants.categories
      .map((category) => {"name": category, "color": CategoryConstants.categoryColors})
      .toList();

  final GlobalKey<ListOfItemsState> _listKey = GlobalKey(); // Create a key for ListOfItems

  void _refreshItems() {
    _listKey.currentState?.loadItems(); // Call the function in ListOfItems
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrimaryHeaderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const HomeAppBar(),
                  const SizedBox(height: Sizes.spaceBtwSections),
                  const SearchContainer(text: 'Search any Item', icon: Icons.search),
                  const SizedBox(height: Sizes.spaceBtwSections),
                  HomeCategorySection(categories: categories),
                ],
              ),
            ),
            const ItemTitleAndExpirySection(title: 'Items'),
            const SizedBox(height: 15),
            ListOfItems(key: _listKey), // Assign key here
          ],
        ),
      ),
      floatingActionButton: AddItemButton(onItemAdded: _refreshItems), // Pass function here
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
