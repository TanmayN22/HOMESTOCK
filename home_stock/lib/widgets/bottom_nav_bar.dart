import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

// Custom Bottom Navigation Bar Widget
class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex; // Selected index to highlight the active item
  final Function(int) onItemSelected; // Callback when an item is selected

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  // Helper method to generate IconButton for the bottom navigation items
  Widget _buildIconButton({
    required IconData icon,
    required int index,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    return IconButton(
      icon: Icon(
        icon,
        size: 25,
        color: selectedIndex == index ? selectedColor : unselectedColor, // Color logic based on selected index
      ),
      onPressed: () => onItemSelected(index), // Trigger onItemSelected callback
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribute the items evenly
        children: <Widget>[
          // Home Icon Button
          _buildIconButton(
            icon: Icons.home,
            index: 0,
            selectedColor: AppColors.primaryColor,
            unselectedColor: AppColors.neutralColor,
          ),

          // Shopping Cart Icon Button
          _buildIconButton(
            icon: Icons.shopping_cart_rounded,
            index: 1,
            selectedColor: AppColors.primaryColor,
            unselectedColor: AppColors.neutralColor,
          ),

          // Delete Icon Button
          _buildIconButton(
            icon: Icons.auto_delete_rounded,
            index: 2,
            selectedColor: AppColors.primaryColor,
            unselectedColor: AppColors.neutralColor,
          ),

          // Profile Icon Button
          _buildIconButton(
            icon: Icons.person,
            index: 3,
            selectedColor: AppColors.primaryColor,
            unselectedColor: AppColors.neutralColor,
          ),
        ],
      ),
    );
  }
}
