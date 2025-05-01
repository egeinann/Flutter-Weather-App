import 'package:bloc/bloc.dart';
import 'package:weather_app/blocs/weatherBloc/weather_state.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/services/city_service.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService weatherService;
  final CityService cityService;

  WeatherCubit(this.weatherService, this.cityService) : super(WeatherInitial());

  // Şehirler listesini alıp hava durumu verilerini al
  void fetchWeatherForCities() async {
    emit(WeatherLoading());

    try {
      List<String> cities = await cityService.fetchCityList();

      // İlk 10 şehirle sınırla (örnek olarak, daha sonra kaldırabilirsin)
      cities = cities.take(10).toList();

      // Aynı anda tüm istekleri gönder
      final results = await Future.wait(
        cities.map((city) async {
          try {
            return await weatherService.fetchWeather(city);
          } catch (e) {
            print("Şehir atlandı: $city - $e");
            return null; // Hatalı olanları null yapıyoruz
          }
        }),
      );

      // Null olmayanları filtrele
      final weatherList = results.whereType<WeatherModel>().toList();

      if (weatherList.isNotEmpty) {
        emit(WeatherLoaded(weatherList));
      } else {
        emit(WeatherError("Hiçbir şehrin hava durumu alınamadı!"));
    }
    } catch (e) {
      emit(WeatherError("Şehirler alınamadı: $e"));
  }
}
}
