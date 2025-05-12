
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// Shimmer widget'ı
Widget customShimmer(Widget child) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: child,
  );
}