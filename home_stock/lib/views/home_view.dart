import 'package:flutter/material.dart';
import 'package:home_stock/utils/constants/sizes.dart';
import 'package:home_stock/widgets/custom_shapes/primary_header_container.dart';
import 'package:home_stock/widgets/custom_widgets/add_item_widget.dart';
import 'package:home_stock/widgets/custom_widgets/category_horizontal_scroll.dart';
import 'package:home_stock/widgets/custom_widgets/category_section.dart';
import 'package:home_stock/widgets/custom_widgets/home_appbar.dart';
import 'package:home_stock/widgets/custom_widgets/search_container_widget.dart';
import 'package:home_stock/utils/constants/categories.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> categories = CategoryConstants.categories.map((category) => {"name": category, "color": CategoryConstants.categoryColors}).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // the custom orange design created
            PrimaryHeaderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Custom app bar created
                  const HomeAppBar(),
                  const SizedBox(height: Sizes.spaceBtwSections),

                  // Search bar
                  const SearchContainer(
                    text: 'Search any Item',
                    icon: Icons.search,
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections),

                  // Categories
                  Column(
                    children: [
                      // Heading of Category
                      const Padding(
                        padding: EdgeInsets.only(left: Sizes.spaceBtwSections),
                        child: CategorySection(
                          title: 'Categories',
                          showActionButton: false,
                        ),
                      ),
                      const SizedBox(height: Sizes.spaceBtwItems),

                      // Categories of items
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: categories.length, // Use dynamic count
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, index) {
                            final category = categories[index];

                            return CategoryHorizontalScroll(category: category);
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const AddItemButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
