import 'package:bloc/bloc.dart';
import 'package:weather_app/blocs/weatherBloc/weather_state.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/services/city_service.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService weatherService;
  final CityService cityService;

  WeatherCubit(this.weatherService, this.cityService) : super(WeatherInitial());

  void fetchWeatherForPopularCities() async {
    emit(WeatherLoading());

    try {
      List<String> popularCities = [
        'New York',
        'London',
        'Paris',
        'Tokyo',
        'Istanbul',
        'Moscow',
        'Los Angeles',
        'Beijing',
        'Berlin',
        'Rome',
        'Dubai',
        'Toronto',
        'Chicago',
        'Mumbai',
        'Seoul',
        'Barcelona',
        'Amsterdam',
        'Sydney',
        'São Paulo',
        'Bangkok',
      ];

      final results = await Future.wait(
        popularCities.map((city) async {
          try {
            return await weatherService.fetchWeather(city);
          } catch (e) {
            print("Şehir atlandı: $city - $e");
            return null;
          }
        }),
      );

      final weatherList = results.whereType<WeatherModel>().toList();

      if (weatherList.isNotEmpty) {
        emit(WeatherLoaded(weatherList));
      } else {
        emit(WeatherError("Hiçbir şehrin hava durumu alınamadı!"));
      }
    } catch (e) {
      emit(WeatherError("Veriler alınamadı: $e"));
    }
  }

  // Seçilen şehir için veri çekme fonksiyonu
  void fetchWeatherForCity(String city) async {
    emit(WeatherLoading());

    try {
      final weather = await weatherService.fetchWeather(city);
      emit(WeatherLoaded([weather])); // Tek bir şehir verisi döndürülüyor
    } catch (e) {
      emit(WeatherError("Şehir için hava durumu alınamadı: $e"));
    }
  }
}
