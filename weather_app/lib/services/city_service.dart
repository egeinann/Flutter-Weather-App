import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<String>> fetchCities(String query) async {
  final url = 'http://192.168.0.10:3000/api/cities?q=$query';
  
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // JSON verisini parse et
    List<String> cities = List<String>.from(json.decode(response.body));
    return cities;
  } else {
    throw Exception('Şehir verileri alınamadı');
  }
}