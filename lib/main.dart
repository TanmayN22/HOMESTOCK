import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homestock/database/db_helper.dart';
import 'package:homestock/utils/helpers/noti_service.dart';
import 'package:homestock/views/home_view.dart';
import 'package:homestock/views/cart_view.dart';
import 'package:homestock/views/bin.dart';
import 'package:homestock/widgets/custom_widgets/bottom_nav_bar.dart';
import 'package:homestock/models/item_model.dart';

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

class _FoodInventoryAppState extends State<FoodInventoryApp>
    with WidgetsBindingObserver {
  final NavigationController controller = Get.put(NavigationController());
  final List<Item> cartItems = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCartItems();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadCartItems();
    }
  }

  Future<void> _loadCartItems() async {
    try {
      final loadedCartItems = await DBHelper.instance.getCartItems();
      setState(() {
        cartItems.clear();
        cartItems.addAll(loadedCartItems);
      });
      debugPrint("Loaded ${cartItems.length} cart items in main.dart");
    } catch (e) {
      debugPrint("Error loading cart items: $e");
    }
  }

  void _onCartChanged() {
    _loadCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Obx(() => _getPage(controller.selectedIndex.value)),
        bottomNavigationBar: Obx(
          () => SizedBox(
            height: 100,
            child: CustomBottomNavBar(
              selectedIndex: controller.selectedIndex.value,
              onItemSelected: (index) {
                controller.changeIndex(index);
                if (index == 1) {
                  _loadCartItems();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage(onCartChanged: _onCartChanged);
      case 1:
        return Cart(cartItems: cartItems);
      case 2:
        return BinPage(cartItems: cartItems, onCartChanged: _onCartChanged);
      default:
        return HomePage(onCartChanged: _onCartChanged);
    }
  }
}
