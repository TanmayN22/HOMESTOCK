import 'package:flutter/material.dart';
import 'package:home_stock/views/home_view.dart';
import 'package:home_stock/views/cart_view.dart';
import 'package:home_stock/views/finished_expired_items_view.dart';
import 'package:home_stock/views/profile_view.dart';
import 'package:home_stock/widgets/bottom_nav_bar.dart';

void main() {
  runApp(const FoodInventoryApp());
}

class FoodInventoryApp extends StatefulWidget {
  const FoodInventoryApp({super.key});

  @override
  State<FoodInventoryApp> createState() => _FoodInventoryAppState();
}

class _FoodInventoryAppState extends State<FoodInventoryApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const Cart(),
    const FinishedExpiredItemsView(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemSelected: _onItemTapped,
        ),
      ),
    );
  }
}
