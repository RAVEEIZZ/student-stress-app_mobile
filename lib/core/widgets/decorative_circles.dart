import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DecorativeCircles extends StatelessWidget {
  const DecorativeCircles({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -60,
          right: -40,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.06),
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: -80,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight.withOpacity(0.08),
            ),
          ),
        ),
        Positioned(
          top: -30,
          left: -50,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.04),
            ),
          ),
        ),
      ],
    );
  }
}

class DecorativeCirclesBottom extends StatelessWidget {
  const DecorativeCirclesBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: -40,
          left: -30,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.05),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: -60,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight.withOpacity(0.06),
            ),
          ),
        ),
      ],
    );
  }
}
