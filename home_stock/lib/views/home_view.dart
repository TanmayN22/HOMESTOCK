import 'package:flutter/material.dart';
import 'package:home_stock/utils/constants/sizes.dart';
import 'package:home_stock/widgets/custom_shapes/primary_header_container.dart';
import 'package:home_stock/widgets/custom_widgets/add_item_widget.dart';
import 'package:home_stock/widgets/custom_widgets/home_appbar.dart';
import 'package:home_stock/widgets/custom_widgets/search_container_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // the custom orange design created
            PrimaryHeaderContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // custom app bar created
                  HomeAppBar(),
                  SizedBox(
                    height: Sizes.spaceBtwSections,
                  ),
                  // Searchbar
                  SearchContainer(
                    text: 'Search any Item',
                    icon: Icons.search,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AddItemButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
