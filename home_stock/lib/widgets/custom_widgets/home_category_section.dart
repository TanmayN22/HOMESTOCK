import 'package:flutter/material.dart';
import 'package:home_stock/widgets/custom_widgets/category_horizontal_scroll.dart';
import 'package:home_stock/widgets/custom_widgets/category_section.dart';
import '../../utils/constants/sizes.dart';

class HomeCategorySection extends StatelessWidget {
  const HomeCategorySection({
    super.key,
    required this.categories,
  });

  final List<Map<String, dynamic>> categories;

  @override
  Widget build(BuildContext context) {
    return Column(
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
    
              return CategoryHorizontalScroll(category: category, onTap: (){},);
            },
          ),
        )
      ],
    );
  }
}
