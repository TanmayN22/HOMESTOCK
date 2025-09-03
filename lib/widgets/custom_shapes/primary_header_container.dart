import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:homestock/utils/themes/app_colors.dart';
import 'package:homestock/widgets/custom_shapes/circular_shape.dart';
import 'package:homestock/widgets/custom_widgets/curved_edges_widget.dart';

// custom orange design created in the background with the curved clip
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
                      backgroundColor: AppColors.primaryColor.withOpacity(1),
                    )),
              ),
              Positioned(
                top: 100,
                right: 100,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 200),
                  child: CircularContainer(
                    backgroundColor: AppColors.primaryColor.withOpacity(1),
                  ),
                ),
              ),
              Positioned(
                top: 100,
                right: 100,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 200),
                  child: CircularContainer(
                    backgroundColor: AppColors.primaryColor.withOpacity(1),
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