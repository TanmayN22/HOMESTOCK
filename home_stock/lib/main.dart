import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_stock/views/home_view.dart';
import 'package:home_stock/views/cart_view.dart';
import 'package:home_stock/views/finished_expired_items_view.dart';
import 'package:home_stock/views/profile_view.dart';
import 'package:home_stock/widgets/custom_widgets/bottom_nav_bar.dart';

void main() {
  runApp(FoodInventoryApp());
}

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}

class FoodInventoryApp extends StatelessWidget {
  FoodInventoryApp({super.key});

  final NavigationController controller = Get.put(NavigationController());

  final List<Widget> _pages = [
    const HomePage(),
    const Cart(),
    const BinPage(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Obx(() => _pages[controller.selectedIndex.value]),
        bottomNavigationBar: Obx(() => SizedBox(
              height: 100,
              child: CustomBottomNavBar(
                selectedIndex: controller.selectedIndex.value,
                onItemSelected: controller.changeIndex,
              ),
            )),
      ),
    );
  }
}
