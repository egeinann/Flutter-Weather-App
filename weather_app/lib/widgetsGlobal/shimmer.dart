import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/utils/colors.dart';

Widget customShimmer(Widget child) {
  return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: AppColors.background,
      child: child,
    );
}