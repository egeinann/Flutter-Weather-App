import 'dart:convert';
import 'package:http/http.dart' as http;

class CityService {
  final String _baseUrl = 'http://10.0.2.2:3000/cities';

  // Şehirler listesini al
  Future<List<String>> fetchCityList() async {
    final url = Uri.parse(_baseUrl);

    try {
      final response = await http.get(url);

      print('Response code: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final List<dynamic> cityList = json.decode(response.body);
        return List<String>.from(cityList);
      } else {
        print('Error: ${response.statusCode}');
        throw Exception('Şehirler alınamadı200');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Şehirler alınamadı23: $e');
    }
  }
}