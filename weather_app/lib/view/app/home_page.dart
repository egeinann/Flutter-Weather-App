import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/blocs/weatherBloc/weather_cubit.dart';
import 'package:weather_app/blocs/weatherBloc/weather_state.dart';



class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sayfa yüklendiği anda hava durumu verilerini almak için cubit'i tetikliyoruz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherCubit>().fetchWeatherForCities();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Hava Durumu'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<WeatherCubit, WeatherState>(
              builder: (context, state) {
                if (state is WeatherLoading) {
                  return Center(child: CircularProgressIndicator());
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
                          subtitle: Text('${weather.temperature}°C, ${weather.description}'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Rüzgar: ${weather.windSpeed} m/s'),
                              Text('Nem: ${weather.humidity}%'),
                            ],
                          ),
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
          ],
        ),
      ),
    );
  }
}
