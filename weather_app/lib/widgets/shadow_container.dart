
import 'package:flutter/material.dart';
import 'package:weather_app/utils/colors.dart';

Widget customShadowContainer({
  required Widget child,
  double borderRadius = 20,
  Color? backgroundColor,
})  {
  return Container(
    decoration: BoxDecoration(
      color: backgroundColor ??
                AppColors.background,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: backgroundColor ??
                AppColors.shadow,
          blurRadius: 1,
          spreadRadius: 1,
          blurStyle: BlurStyle.inner,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: child,
    ),
  );
}
