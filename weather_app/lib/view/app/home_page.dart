import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:weather_app/blocs/weatherBloc/weather_cubit.dart';
import 'package:weather_app/blocs/weatherBloc/weather_state.dart';
import 'package:weather_app/utils/icons.dart';
import 'package:weather_app/view/app/detail_page.dart';
import 'package:weather_app/view/app/search_page.dart';
import 'package:weather_app/widgets/button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sayfa yüklendiği anda hava durumu verilerini almak için cubiti tetikliyoruz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherCubit>().fetchWeatherForPopularCities();
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.red,
                child: buildPopularCities(),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.green,
              ),
            ),
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
            child: Column(
              children: state.weatherList.map((weather) {
                final backgroundUrl = context
                    .read<WeatherCubit>()
                    .getCityBackgroundUrl(weather.cityName);

                return Container(
                  height: 150,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(backgroundUrl),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4), BlendMode.darken),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      '${weather.cityName}, ${weather.country}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    subtitle: Text(
                      '${weather.temperature}°C, ${weather.description}',
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Wind speed: ${weather.windSpeed} m/s',
                              style: TextStyle(color: Colors.white)),
                          Text('humidity: ${weather.humidity}%',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
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
                  ),
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
