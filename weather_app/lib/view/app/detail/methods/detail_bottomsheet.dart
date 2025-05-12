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
        backgroundColor: Colors.pink,
        title: "humidity",
        value: "${weather.humidity}%",
        image: IconImages.rainIcon),
    MoredetailsModel(
        backgroundColor: Colors.blue,
        title: "wind\nSpeed",
        value: "${weather.windSpeed}m/s",
        image: IconImages.tornadoIcon),
    MoredetailsModel(
        backgroundColor: Colors.green,
        title: "temp\nMin",
        value: "${weather.tempMin}°",
        image: IconImages.minTemp),
    MoredetailsModel(
      backgroundColor: Colors.orange,
      title: "temp\nMax",
      value: "${weather.tempMax}°",
      image: IconImages.maxTemp,
    ),
  ];
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
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
            initialChildSize: 0.075,
            minChildSize: 0.075,
            maxChildSize: 0.5,
            builder: (context, scrollController) {
              return GestureDetector(
                onTap: () async {
                  if (_sheetController.size <= 0.11) {
                    await _sheetController.animateTo(
                      0.5,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    await _sheetController.animateTo(
                      0.075,
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
                                height: 180,
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
                                            height: 150,
                                            width: double.infinity,
                                            backgroundColor:
                                                detail.backgroundColor,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  FittedBox(
                                                    child: Text(
                                                      detail.title,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineLarge,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  FittedBox(
                                                    child: Text(
                                                      detail.value,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineLarge,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                    CachedNetworkImage(
                                      imageUrl: detail.image,
                                      fit: BoxFit.scaleDown,
                                      height: 50,
                                      placeholder: (context, url) =>
                                          customShimmer(
                                        Container(
                                          width: 50,
                                          height: 50,
                                          color: Colors.grey[300],
                                        ),
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
