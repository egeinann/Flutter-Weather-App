import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/widgetsGlobal/shimmer.dart';

Widget detailBuildIcon(WeatherModel weather) {
  return TweenAnimationBuilder<Offset>(
    tween: Tween(begin: Offset(-1, 0), end: Offset.zero),
    duration: Duration(milliseconds: 1000),
    curve: Curves.easeOut,
    builder: (context, offset, child) {
      return Transform.translate(
        offset: Offset(offset.dx * -500, 0), // 100 px solda başla
        child: Opacity(
          opacity: 1 - offset.dx.abs(), // hafif fade etkisi
          child: child,
        ),
      );
    },
    child: CachedNetworkImage(
      imageUrl: weather.iconAsset, // Burada iconAsset artık bir URL olacak
      fit: BoxFit.scaleDown,
      height: 40.sp,
      placeholder: (context, url) {
        // Shimmer sadece görsel yüklenene kadar gösterilsin
        return customShimmer(SizedBox());
      },
      errorWidget: (context, url, error) =>
          Icon(Icons.error), // Hata durumunda bir ikon
    ),
  );
}
