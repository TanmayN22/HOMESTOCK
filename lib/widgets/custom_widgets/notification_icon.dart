import 'package:flutter/material.dart';
import 'package:homestock/utils/themes/app_colors.dart';


// the notification icon with number of notifications is being shown
class NotificationIcon extends StatelessWidget {
  const NotificationIcon({
    super.key,
    this.iconColor,
    required this.onPressed,
  });

  final Color? iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none_rounded,
            size: 30,
          ),
          color: iconColor,
          onPressed: onPressed,
        ),
        Positioned(
            right: 8,
            top: 8,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(color: AppColors.secondaryColor, borderRadius: BorderRadius.circular(100)),
              child: Center(
                child: Text(
                  '1',
                  style: Theme.of(context).textTheme.labelLarge!.apply(color: AppColors.whitecolor, fontSizeFactor: 0.8),
                ),
              ),
            ))
      ],
    );
  }
}