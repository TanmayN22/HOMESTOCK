import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_stock/utils/themes/app_colors.dart';
import 'package:home_stock/widgets/custom_widgets/appbar.dart';
import 'package:home_stock/widgets/custom_widgets/notification_icon.dart';

// final custom home page's appbar
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppbar(
      title: Row(
        children: [
// In your HomeAppBar widget:
          Text(
            'HOME',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          Text(
            'STOCK',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w300),
          ),
        ],
      ),
      actions: [
        NotificationIcon(
          onPressed: () {},
          iconColor: AppColors.whitecolor,
        ),
        Icon(
          Icons.circle_rounded,
          color: AppColors.whitecolor,
          size: 30,
        )
      ],
    );
  }
}
