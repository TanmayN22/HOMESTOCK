import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:home_stock/utils/themes/app_colors.dart';
import 'package:home_stock/widgets/curved_edges_widget.dart';
import 'package:home_stock/widgets/custom_shapes/circular_shape.dart';
import 'package:home_stock/widgets/custom_shapes/curved_edge_border.dart';

class PrimaryHeaderContainer extends StatelessWidget {
  const PrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CurvedEdgesWidget(
      child: Container(
        height: 400,
        decoration: ShapeDecoration(
          shape: const CurvedBorderShape(),
          color: AppColors.whitecolor,
        ),
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          child: Stack(
            children: [
              Positioned(
                top: -100,
                right: -80,
                child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 200),
                    child: CircularContainer(
                      backgroundColor: AppColors.primaryColor.withOpacity(0.75),
                    )),
              ),
              Positioned(
                top: 100,
                right: 100,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 200),
                  child: CircularContainer(
                    backgroundColor: AppColors.primaryColor.withOpacity(0.75),
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
