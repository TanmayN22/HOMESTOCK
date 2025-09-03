import 'package:flutter/material.dart';
import 'package:homestock/utils/constants/sizes.dart';
import 'package:homestock/widgets/custom_shapes/primary_header_container.dart';
import 'package:homestock/widgets/custom_widgets/add_item_widget.dart';
import 'package:homestock/widgets/custom_widgets/body_header_section.dart';
import 'package:homestock/widgets/custom_widgets/home_appbar.dart';
import 'package:homestock/widgets/custom_widgets/home_category_section.dart';
import 'package:homestock/widgets/custom_widgets/items_list.dart';
import 'package:homestock/utils/constants/categories.dart';
import 'package:homestock/widgets/custom_widgets/category_section.dart';
import 'package:homestock/utils/themes/app_colors.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onCartChanged;

  const HomePage({super.key, this.onCartChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> categories =
      CategoryConstants.categories
          .map(
            (category) => {
              "name": category,
              "color": CategoryConstants.categoryColors,
            },
          )
          .toList();

  final GlobalKey<ListOfItemsState> _listKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();

  String? selectedCategory;
  String? searchQuery;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text;
      });
      _listKey.currentState?.loadItems(
        category: selectedCategory,
        searchQuery: searchQuery,
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshItems() {
    _listKey.currentState?.loadItems(
      category: selectedCategory,
      searchQuery: searchQuery,
    );
    widget.onCartChanged?.call();
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
    _listKey.currentState?.loadItems(
      category: category,
      searchQuery: searchQuery,
    );
  }

  void _onShowAllItems() {
    setState(() {
      selectedCategory = null;
    });
    _listKey.currentState?.loadItems(searchQuery: searchQuery);
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.defaultSpace,
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search any Item',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: AppColors.whitecolor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Sizes.cardRadiusMd,
                          ),
                          borderSide: BorderSide(
                            color: AppColors.neutralVariantColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Sizes.cardRadiusMd,
                          ),
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections),
                  const Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: CategorySection(
                      title: 'Categories',
                      showActionButton: false,
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections / 2),
                  HomeCategorySection(
                    categories: categories,
                    onCategorySelected: _onCategorySelected,
                  ),
                ],
              ),
            ),
            ItemTitleAndExpirySection(
              title: selectedCategory ?? 'Items',
              onTitlePressed: _onShowAllItems,
            ),
            const SizedBox(height: 15),
            ListOfItems(
              key: _listKey,
              selectedCategory: selectedCategory,
              searchQuery: searchQuery,
              onCartChanged: widget.onCartChanged,
            ),
          ],
        ),
      ),
      floatingActionButton: AddItemButton(onItemAdded: _refreshItems),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
