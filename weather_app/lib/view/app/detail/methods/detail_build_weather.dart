import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/utils/colors.dart';

Widget detailBuildWeather(WeatherModel weather, BuildContext context) {
  return TweenAnimationBuilder<Offset>(
    tween: Tween(begin: Offset(-1, 0), end: Offset.zero),
    duration: Duration(milliseconds: 800),
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
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              weather.description,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.bigTextLight,
                Colors.transparent,
              ],
              stops: [0.3, 0.9],
            ).createShader(
              Rect.fromLTWH(1, 0, bounds.width, bounds.height),
            );
          },
          blendMode: BlendMode.dstIn,
          child: Text(
            '${weather.temperature}°',
            style: TextStyle(
              fontSize: 50.sp,
              color: AppColors.bigTextLight,
            ),
          ),
        ),
      ],
    ),
  );
}
