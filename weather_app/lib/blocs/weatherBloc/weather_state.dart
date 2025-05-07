// weather_state.dart

import 'package:weather_app/models/weather_model.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

/// Popüler şehirlerden dönen liste
class WeatherLoaded extends WeatherState {
  final List<WeatherModel> weatherList;
  WeatherLoaded(this.weatherList);
}

/// Arama ile dönen tek şehir
class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}

class WeatherSearchLoaded extends WeatherState {
  final WeatherModel weather;
  WeatherSearchLoaded(this.weather);
}
