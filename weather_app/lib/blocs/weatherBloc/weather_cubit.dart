import 'package:bloc/bloc.dart';
import 'package:weather_app/blocs/weatherBloc/weather_state.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/utils/image_strings.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService weatherService;

  bool _isInitialized = false; // ilk yükleme kontrolü
  WeatherCubit(this.weatherService) : super(WeatherInitial());

  // *** POPÜLER ŞEHİRLER İÇİN WEATHER VERİLERİ ***
  void fetchWeatherForPopularCities() async {
    if (_isInitialized) return; // Zaten yüklendiyse tekrar yükleme
    _isInitialized = true;
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
        'Seoul',
        'Barcelona',
        'Amsterdam',
        'Sydney',
        'São Paulo',
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

  // *** POPÜLER ŞEHİRLERE GÖRE BACKGORUND GÖSTERİMİ ***
  String getCityBackgroundUrl(String cityName) {
    // Küçük harfe çevir, boşlukları kaldır, özel karakterleri temizle
    final lower = cityName
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('ã', 'a') // São Paulo → saopaulo
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ç', 'c')
        .replaceAll('ü', 'u');

    switch (lower) {
      case 'amsterdam':
        return CityBackgrounds.amsterdam;
      case 'barcelona':
        return CityBackgrounds.barcelona;
      case 'beijing':
        return CityBackgrounds.beijing;
      case 'berlin':
        return CityBackgrounds.berlin;
      case 'chicago':
        return CityBackgrounds.chicago;
      case 'dubai':
        return CityBackgrounds.dubai;
      case 'istanbul':
        return CityBackgrounds.istanbul;
      case 'london':
        return CityBackgrounds.london;
      case 'losangeles':
        return CityBackgrounds.losangeles;
      case 'moscow':
        return CityBackgrounds.moscow;
      case 'newyork':
        return CityBackgrounds.newyork;
      case 'paris':
        return CityBackgrounds.paris;
      case 'rome':
        return CityBackgrounds.rome;
      case 'saopaulo':
        return CityBackgrounds.saopaulo;
      case 'seoul':
        return CityBackgrounds.seoul;
      case 'sydney':
        return CityBackgrounds.sydney;
      case 'tokyo':
        return CityBackgrounds.tokyo;
      case 'toronto':
        return CityBackgrounds.toronto;
      default:
        return CityBackgrounds.istanbul; // fallback görsel
    }
  }
}
