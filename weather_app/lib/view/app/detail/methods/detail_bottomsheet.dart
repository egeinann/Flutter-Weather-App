// *** BOTTOM KAYDIRILABİLİR SHEET ***
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/models/moreDetails_model.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/widgetsGlobal/blur_container.dart';
import 'package:weather_app/widgetsGlobal/shadow_container.dart';
import 'package:weather_app/widgetsGlobal/shimmer.dart';

Widget detailBottomSheet(List<MoredetailsModel> moreDetails) {
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
          height: 50.h,
          width: 90.w,
          child: DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.1,
            minChildSize: 0.1,
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
                      0.1,
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
                                height: 150,
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
                                            height: 120,
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
                                                    ),
                                                  ),
                                                  FittedBox(
                                                    child: Text(
                                                      detail.value,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineLarge,
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
