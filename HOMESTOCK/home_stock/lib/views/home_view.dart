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
import 'package:home_stock/widgets/custom_widgets/category_section.dart'; // ✅ Make sure this is imported!

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> categories = CategoryConstants.categories
      .map((category) => {
            "name": category,
            "color": CategoryConstants.categoryColors,
          })
      .toList();

  final GlobalKey<ListOfItemsState> _listKey = GlobalKey();

  String? selectedCategory; // Track selected category for filtering

  void _refreshItems() {
    _listKey.currentState?.loadItems(category: selectedCategory);
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
    _listKey.currentState?.loadItems(category: category);
  }

  void _onShowAllItems() {
    setState(() {
      selectedCategory = null;
    });
    _listKey.currentState?.loadItems();
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

                  const SearchContainer(
                    text: 'Search any Item',
                    icon: Icons.search,
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections),

                  // ✅ "Categories" title
                  const Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: CategorySection(
                      title: 'Categories',
                      showActionButton: false,
                    ),
                  ),

                  const SizedBox(height: Sizes.spaceBtwSections / 2),

                  // ✅ Horizontal category list with selection callback
                  HomeCategorySection(
                    categories: categories,
                    onCategorySelected: _onCategorySelected,
                  ),
                ],
              ),
            ),

            ItemTitleAndExpirySection(
              title: 'Items',
              onTitlePressed: _onShowAllItems,
            ),
            const SizedBox(height: 15),

            // ✅ List of items, filtered by selectedCategory
            ListOfItems(
              key: _listKey,
              selectedCategory: selectedCategory,
            ),
          ],
        ),
      ),

      // ✅ Refreshes item list when adding a new item
      floatingActionButton: AddItemButton(onItemAdded: _refreshItems),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      // remove this later
    );
  }
}
