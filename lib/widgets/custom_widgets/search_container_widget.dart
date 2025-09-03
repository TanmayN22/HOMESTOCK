import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homestock/utils/constants/sizes.dart';
import 'package:homestock/utils/device/device_utility.dart';
import 'package:homestock/utils/themes/app_colors.dart';


class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key,
    required this.text,
    this.icon,
    this.onTap,
  });

  final String text;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
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
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}