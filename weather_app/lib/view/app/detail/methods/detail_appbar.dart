// *** APPBAR KISMI ***
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/icons.dart';

Widget detailAppBar(BuildContext context, WeatherModel weather) {
  return TweenAnimationBuilder<Offset>(
    tween: Tween(begin: Offset(-1, 0), end: Offset.zero),
    duration: Duration(milliseconds: 600),
    curve: Curves.easeOut,
    builder: (context, offset, child) {
      return Transform.translate(
        offset: Offset(offset.dx * -500, 0), // 100 px sola kaydırılmış başlar
        child: Opacity(
          opacity: 1 - offset.dx.abs(), // Girişte hafif fade etkisi
          child: child,
        ),
      );
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            FocusScope.of(context).unfocus();
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.background,
            size: 22.sp,
          ),
        ),
        Row(
          children: [
            Text(
              "${weather.cityName} ${weather.country}",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            SizedBox(width: 5),
            Icon(
              AppIcons.location,
              color: AppColors.background,
            ),
          ],
        ),
      ],
    ),
  );
}
