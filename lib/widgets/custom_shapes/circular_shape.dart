import 'package:flutter/material.dart';
import 'package:homestock/utils/themes/app_colors.dart';


class CircularContainer extends StatelessWidget {
  const CircularContainer({
    super.key,
    this.widht = 400,
    this.height = 400,
    this.radius = 400,
    this.padding = 0,
    this.child,
    this.backgroundColor = AppColors.primaryColor,
  });

  final double? widht;
  final double? height;
  final double radius;
  final double padding;
  final Widget? child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widht,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
      ),
    );
  }
}