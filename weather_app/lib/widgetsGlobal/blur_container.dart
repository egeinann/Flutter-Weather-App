import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/utils/colors.dart';

Widget customBlurContainer({
  required Widget child,
  double borderRadius = 20,
  Color? backgroundColor,
  double? widht,
  double? height,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: Stack(
      children: [
        Positioned.fill(
          child: Container(
            width: widht,
            height: height,
            color: backgroundColor?.withOpacity(0.4) ??
                AppColors.background.withOpacity(0.4),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 3,
                sigmaY: 3,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        child,
      ],
    ),
  );
}
