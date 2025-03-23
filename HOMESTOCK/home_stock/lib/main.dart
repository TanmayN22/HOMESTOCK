import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_stock/utils/helpers/noti_service.dart';
import 'package:home_stock/views/home_view.dart';
import 'package:home_stock/views/cart_view.dart';
import 'package:home_stock/views/finished_expired_items_view.dart';
import 'package:home_stock/views/profile_view.dart';
import 'package:home_stock/widgets/custom_widgets/bottom_nav_bar.dart';
import 'package:home_stock/models/item_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotiService().initNotification();
  runApp(const FoodInventoryApp());
}

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}

class FoodInventoryApp extends StatefulWidget {
  const FoodInventoryApp({super.key});

  @override
  State<FoodInventoryApp> createState() => _FoodInventoryAppState();
}

class _FoodInventoryAppState extends State<FoodInventoryApp> {
  final NavigationController controller = Get.put(NavigationController());

  // ✅ Shared cartItems list
  final List<Item> cartItems = [];

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Obx(() => _getPage(controller.selectedIndex.value)),
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

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return Cart(cartItems: cartItems); // ✅ CartPage (updated name)
      case 2:
        return BinPage(
          cartItems: cartItems,
          onCartChanged: () {},
        );
      case 3:
        return const Profile();
      default:
        return const HomePage();
    }
  }
}
