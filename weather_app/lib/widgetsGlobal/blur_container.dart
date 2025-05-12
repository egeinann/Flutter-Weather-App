import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/utils/colors.dart';

Widget customBlurContainer({
  required Widget child,
  double borderRadius = 20,
  Color? backgroundColor,
  double? widht,
  double? height,
  double x = 3,
  double y = 3,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: Container(
      width: widht,
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: backgroundColor?.withOpacity(0.4) ??
                  AppColors.background.withOpacity(0.4),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: x,
                  sigmaY: y,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          child,
        ],
      ),
    ),
  );
}
