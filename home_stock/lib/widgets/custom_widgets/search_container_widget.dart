import 'package:flutter/material.dart';
import 'package:home_stock/utils/constants/sizes.dart';
import 'package:home_stock/utils/device/device_utlity.dart';
import 'package:home_stock/utils/themes/app_colors.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key,
    required this.text,
    this.icon,
  });

  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.defaultSpace),
      child: Container(
        width: DeviceUtils.getScreenWidth(context),
        padding: const EdgeInsets.all(Sizes.md),
        decoration: BoxDecoration(
          color: AppColors.whitecolor,
          borderRadius: BorderRadius.circular(Sizes.cardRadiusMd),
          border: Border.all(color: AppColors.neutralVariantColor),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.neutralColor,
              size: Sizes.iconLg,
            ),
            const SizedBox(
              width: Sizes.spaceBtwItems,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.labelLarge,
            )
          ],
        ),
      ),
    );
  }
}
