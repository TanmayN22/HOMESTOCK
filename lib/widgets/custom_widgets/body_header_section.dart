import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homestock/utils/constants/sizes.dart';
import 'package:homestock/widgets/custom_shapes/expiry_boxes.dart';

class ItemTitleAndExpirySection extends StatelessWidget {
  const ItemTitleAndExpirySection({super.key, required this.title, this.onTitlePressed});

  final String title;
  final VoidCallback? onTitlePressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: Sizes.spaceBtwSections),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: onTitlePressed,
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: Sizes.spaceBtwSections),
            child: Row(
              children: [
                ExpiryBox(
                  color: Colors.green,
                ),
                ExpiryBox(
                  color: Colors.yellow,
                ),
                ExpiryBox(
                  color: Colors.orange,
                ),
                ExpiryBox(
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}