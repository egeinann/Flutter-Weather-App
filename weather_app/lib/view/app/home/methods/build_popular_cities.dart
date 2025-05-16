import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/blocs/weatherBloc/weather_cubit.dart';
import 'package:weather_app/blocs/weatherBloc/weather_state.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/view/app/detail/page/detail_page.dart';
import 'package:weather_app/widgetsGlobal/shimmer.dart';

BlocBuilder<WeatherCubit, WeatherState> buildPopularCities() {
  return BlocBuilder<WeatherCubit, WeatherState>(
    builder: (context, state) {
      if (state is WeatherLoading) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 30.h), // Yukarıdan 30 birim boşluk
                ...List.generate(5, (index) => _buildShimmerCard()),
              ],
            ),
          ),
        );
      } else if (state is WeatherLoaded) {
        return RefreshIndicator(
          onRefresh: () async {
            await context
                .read<WeatherCubit>()
                .refreshWeather(); // Yenileme fonksiyonu
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), // zorunlu!
            child: Column(
              children: [
                SizedBox(height: 30.h),
                ...state.weatherList.map((weather) {
                  final backgroundUrl = context
                      .read<WeatherCubit>()
                      .getCityBackgroundUrl(weather.cityName);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          duration: const Duration(milliseconds: 200),
                          type: PageTransitionType.rightToLeftWithFade,
                          child: DetailPage(weather: weather),
                        ),
                      );
                    },
                    child: Container(
                      height: 150,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: backgroundUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => customShimmer(
                                Container(color: Colors.grey[100]),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.red,
                                child: const Icon(Icons.error,
                                    color: Colors.white),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: customShimmer(
                                          Text(
                                            "${weather.cityName}-${weather.country}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: AppColors.background
                                              .withOpacity(0.7),
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                        child: customShimmer(
                                          Text(
                                            weather.description,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        customShimmer(
                                          Text(
                                            "${weather.temperature}°C",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge,
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            customShimmer(
                                              Text(
                                                'Wind speed: ${weather.windSpeed} m/s',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium,
                                              ),
                                            ),
                                            customShimmer(
                                              Text(
                                                'Humidity: ${weather.humidity}%',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        );
      } else if (state is WeatherError) {
        return Center(
          child: Text(
            state.message,
            style: const TextStyle(color: Colors.red),
          ),
        );
      }
      return const SizedBox.shrink();
    },
  );
}

// *** SHIMMER EFFEKT ***
Widget _buildShimmerCard() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.white,
      child: Container(
        height: 18.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 20,
                      color: Colors.white,
                    ),
                    Container(
                      width: 80,
                      height: 15,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(width: 50, height: 30, color: Colors.white),
                    Column(
                      children: [
                        Container(width: 70, height: 15, color: Colors.white),
                        SizedBox(height: 4),
                        Container(width: 50, height: 15, color: Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
