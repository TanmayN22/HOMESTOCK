import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_stock/utils/device/device_utlity.dart';
import 'package:home_stock/views/home_view.dart';
import 'package:home_stock/views/cart_view.dart';
import 'package:home_stock/views/finished_expired_items_view.dart';
import 'package:home_stock/views/profile_view.dart';
import 'package:home_stock/widgets/custom_widgets/bottom_nav_bar.dart';

void main() {
  runApp(const FoodInventoryApp());
}

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}

class FoodInventoryApp extends StatelessWidget {
  const FoodInventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.put(NavigationController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Obx(() => _pages[controller.selectedIndex.value]),
        bottomNavigationBar: SizedBox(
          height: DeviceUtils.getBottomNavigationBarHeight(),
          child: CustomBottomNavBar(
            selectedIndex: controller.selectedIndex.value,
            onItemSelected: (index) => controller.changeIndex(index),
          ),
        ),
      ),
    );
  }
}

final List<Widget> _pages = [
  const HomePage(),
  const Cart(),
  const FinishedExpiredItemsView(),
  const Profile(),
];
