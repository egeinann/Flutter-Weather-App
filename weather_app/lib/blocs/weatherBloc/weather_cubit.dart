import 'package:bloc/bloc.dart';
import 'package:weather_app/blocs/weatherBloc/weather_state.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService weatherService;

  WeatherCubit(this.weatherService) : super(WeatherInitial());

  // Sabit şehirler için hava durumu verilerini al
  void fetchWeatherForCities() async {
    emit(WeatherLoading());

    List<String> cities = ['Istanbul', 'Edirne']; // Hardcoded şehirler
    List<WeatherModel> weatherList = [];

    for (String city in cities) {
      try {
        final weather = await weatherService.fetchWeather(city);
        weatherList.add(weather);
      } catch (e) {
        emit(WeatherError("Hava durumu alınamadı"));
        return;
      }
    }

    emit(WeatherLoaded(weatherList)); // Şehirlerin verilerini yüklüyoruz
  }
}