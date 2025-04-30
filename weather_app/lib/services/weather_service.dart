import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather_model.dart';

class WeatherService {
  final String _baseUrl = 'http://10.0.2.2:3000/weather'; // Localhost (Android için 10.0.2.2)

  Future<WeatherModel> fetchWeather(String cityName) async {
    final url = Uri.parse('$_baseUrl?city=$cityName');

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
