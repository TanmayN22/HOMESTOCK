import 'package:flutter/material.dart';
import 'package:homestock/widgets/custom_widgets/category_horizontal_scroll.dart';

class HomeCategorySection extends StatelessWidget {
  const HomeCategorySection({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  final List<Map<String, dynamic>> categories;
  final void Function(String category) onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryHorizontalScroll(
            category: category,
            onTap: () {
              onCategorySelected(category['name']); // <-- passes category name on tap
            },
          );
        },
      ),
    );
  }
}