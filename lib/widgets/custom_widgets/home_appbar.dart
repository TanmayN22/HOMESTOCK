import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homestock/widgets/custom_widgets/appbar.dart';

// final custom home page's appbar
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppbar(
      title: Row(
        children: [
          Text('HOME', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          Text(
            'STOCK',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w300),
          ),
        ],
      ),
      // actions: [
      //   // NotificationIcon(
      //   //   onPressed: () {},
      //   //   iconColor: AppColors.whitecolor,
      //   // ),
      // ],
    );
  }
}
