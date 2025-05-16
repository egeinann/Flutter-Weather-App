import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather_model.dart';

class WeatherService {
  final String _baseUrl = 'http://192.168.0.10:3000/weather';

  Future<WeatherModel> fetchWeather(String cityName) async {
    try {
      final url = Uri.parse('$_baseUrl?city=$cityName');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // JSON verisinin beklenen yapıda olup olmadığını kontrol et
        if (data is Map<String, dynamic>) {
          return WeatherModel.fromJson(data);
        } else {
          throw Exception('Beklenmeyen veri biçimi alındı.');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
            errorData['message'] ?? 'Hava durumu verisi alınamadı.');
      }
    } catch (e) {
      throw Exception('Hava durumu alınırken hata oluştu: $e');
    }
  }
}
