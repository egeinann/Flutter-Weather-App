import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/weather_model.dart';

class WeatherService {
  final String _apiKey = '743039ab6e01c2de7ad71b56d95a428d';
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherModel> fetchWeather(String cityName) async {
    final url =
        Uri.parse('$_baseUrl?q=$cityName&appid=$_apiKey&units=metric&lang=tr');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      final errorData = json.decode(response.body);
      throw Exception(
          errorData['message'] ?? 'Could not fetch weather data!');
    }
  }
}
