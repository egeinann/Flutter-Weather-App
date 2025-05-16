// *** BOTTOM KAYDIRILABİLİR SHEET ***
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/models/moreDetails_model.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/image_strings.dart';
import 'package:weather_app/widgetsGlobal/blur_container.dart';
import 'package:weather_app/widgetsGlobal/shadow_container.dart';
import 'package:weather_app/widgetsGlobal/shimmer.dart';

Widget detailBottomSheet(WeatherModel weather) {
  final List<MoredetailsModel> moreDetails = [
    MoredetailsModel(
        backgroundColor: Color(0xFF129990),
        title: "humidity",
        value: "${weather.humidity}%",
        image: IconImages.rainIcon),
    MoredetailsModel(
        backgroundColor: Color(0xFF393E46),
        title: "wind\nSpeed",
        value: "${weather.windSpeed}m/s",
        image: IconImages.tornadoIcon),
    MoredetailsModel(
        backgroundColor: Color(0xFFC95792),
        title: "temp\nMin",
        value: "${weather.tempMin}°",
        image: IconImages.minTemp),
    MoredetailsModel(
      backgroundColor: Color(0xFF948979),
      title: "temp\nMax",
      value: "${weather.tempMax}°",
      image: IconImages.maxTemp,
    ),
  ];
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  final double max = 0.5;
  final double min = 0.075;
  final double initial = 0.075;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Future.delayed(const Duration(milliseconds: 600), () async {
      if (_sheetController.isAttached) {
        await _sheetController.animateTo(
          max,
          duration: Duration(milliseconds: 700),
          curve: Curves.easeOut,
        );
      }
    });
  });

  return Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 60.h,
          width: 90.w,
          child: DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: initial,
            minChildSize: min,
            maxChildSize: max,
            builder: (context, scrollController) {
              return GestureDetector(
                onTap: () async {
                  if (_sheetController.size < max) {
                    await _sheetController.animateTo(
                      max,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    await _sheetController.animateTo(
                      min,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: customBlurContainer(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        Container(
                          height: 5.h,
                          child: Align(
                            alignment: Alignment.center,
                            child: Divider(
                              endIndent: 30.w,
                              indent: 30.w,
                              color: AppColors.shadow,
                              thickness: 2,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: moreDetails.map((detail) {
                            return Expanded(
                              child: Container(
                                height: 24.h,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: customShadowContainer(
                                            height: 20.h,
                                            width: double.infinity,
                                            backgroundColor:
                                                detail.backgroundColor,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                FittedBox(
                                                  child: Text(
                                                    detail.title,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                FittedBox(
                                                  child: Text(
                                                    detail.value,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                    CachedNetworkImage(
                                      imageUrl: detail.image,
                                      fit: BoxFit.scaleDown,
                                      height: 30.sp,
                                      placeholder: (context, url) =>
                                          customShimmer(
                                        SizedBox(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
