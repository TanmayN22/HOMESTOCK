import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homestock/utils/constants/sizes.dart';
import 'package:homestock/utils/themes/app_colors.dart';

class CategoryHorizontalScroll extends StatelessWidget {
  const CategoryHorizontalScroll({
    super.key,
    required this.category, required this.onTap,
  });

  final Map<String, dynamic> category;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Prevents unnecessary space
          children: [
            // Circle with first letter of category
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(Sizes.sm),
              decoration: BoxDecoration(
                color: category["color"], // Dynamic color
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  category["name"].isNotEmpty ? category["name"][0].toUpperCase() : '?', // First letter
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutralVariantColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4), // Adds a bit of space
      
            // Category name below (Now wrapped properly)
            SizedBox(
              width: 70, // Increased width to prevent overflow
              child: Text(
                category["name"],
                style: GoogleFonts.poppins(
                  fontSize: 14, // Slightly larger for better readability
                  fontWeight: FontWeight.w600, // Makes it bolder
                  color: Colors.black,
                ),
                maxLines: 1, // Allows text to wrap if needed
                overflow: TextOverflow.visible, // Ensures text is readable
                textAlign: TextAlign.center,
                softWrap: true, // Ensures it wraps properly
              ),
            ),
          ],
        ),
      ),
    );
  }
}