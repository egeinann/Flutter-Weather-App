import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:weather_app/blocs/weatherBloc/weather_cubit.dart';
import 'package:weather_app/blocs/weatherBloc/weather_state.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/icons.dart';
import 'package:weather_app/view/app/detail_page.dart';
import 'package:weather_app/view/app/search_page.dart';
import 'package:weather_app/widgets/button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Cubit çağrısı burada tetikleniyor
    context.read<WeatherCubit>().fetchWeatherForPopularCities();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: buildPopularCities()),
            Expanded(child: Container(color: Colors.green)),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 5, bottom: 20),
        child: customButton(
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                duration: const Duration(milliseconds: 200),
                type: PageTransitionType.bottomToTop,
                child: SearchPage(),
              ),
            );
          },
          child: Icon(AppIcons.search),
        ),
      ),
    );
  }

  // *** BUILD POPULAR CITIES ***
  BlocBuilder<WeatherCubit, WeatherState> buildPopularCities() {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is WeatherLoaded) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: state.weatherList.map((weather) {
                final backgroundUrl = context
                    .read<WeatherCubit>()
                    .getCityBackgroundUrl(weather.cityName);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        duration: const Duration(milliseconds: 200),
                        type: PageTransitionType.rightToLeft,
                        child: DetailPage(weather: weather),
                      ),
                    );
                  },
                  child: Container(
                      height: 150,
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(backgroundUrl),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5), BlendMode.darken),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "${weather.cityName}-${weather.country}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.background.withOpacity(0.7),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    weather.description,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    weather.temperature.toString() + "°C",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                          'Wind speed: ${weather.windSpeed} m/s',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium),
                                      Text('humidity: ${weather.humidity}%',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                );
              }).toList(),
            ),
          );
        } else if (state is WeatherError) {
          return Text(state.message, style: TextStyle(color: Colors.red));
        }
        return SizedBox.shrink();
      },
    );
  }
}
