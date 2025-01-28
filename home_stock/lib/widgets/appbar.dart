import 'package:flutter/material.dart';
import 'package:home_stock/utils/constants/sizes.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  Size get preferredSize => const Size.fromHeight(Sizes.appBarHeight);
}
