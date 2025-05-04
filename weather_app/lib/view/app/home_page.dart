import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:weather_app/blocs/weatherBloc/weather_cubit.dart';
import 'package:weather_app/blocs/weatherBloc/weather_state.dart';
import 'package:weather_app/utils/icons.dart';
import 'package:weather_app/utils/lottie_strings.dart';
import 'package:weather_app/view/app/detail_page.dart';
import 'package:weather_app/view/app/search_page.dart';
import 'package:weather_app/widgets/button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sayfa yüklendiği anda hava durumu verilerini almak için cubit'i tetikliyoruz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherCubit>().fetchWeatherForPopularCities();
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading) {
              return Center(
                child: Lottie.asset(
                  LottieFiles.loading,
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              );
            } else if (state is WeatherLoaded) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.weatherList.length,
                itemBuilder: (context, index) {
                  var weather = state.weatherList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text('${weather.cityName}, ${weather.country}'),
                      subtitle: Text(
                          '${weather.temperature}°C, ${weather.description}'),
                      trailing: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Rüzgar: ${weather.windSpeed} m/s'),
                            Text('Nem: ${weather.humidity}%'),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            duration: const Duration(milliseconds: 200),
                            type: PageTransitionType.rightToLeft,
                            child: DetailPage(
                              weather: weather,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (state is WeatherError) {
              return Text(state.message, style: TextStyle(color: Colors.red));
            }
            return SizedBox.shrink(); // İlk başta bir şey gösterme
          },
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
}
