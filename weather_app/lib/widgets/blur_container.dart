import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/utils/colors.dart';

Widget customBlurContainer({
  required Widget child,
  double borderRadius = 20,
  Color? backgroundColor,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: backgroundColor?.withOpacity(0.1) ??
                AppColors.background.withOpacity(0.4),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
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
