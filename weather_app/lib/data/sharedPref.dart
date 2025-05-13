import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart'; // modelin yolunu senin yapına göre düzenle

class SharedPreferencesService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // 🔹 Onboarding Durumu
  static Future<void> setOnboardingCompleted(bool value) async {
    await _prefs?.setBool('onboarding_completed', value);
  }

  static bool getOnboardingCompleted() {
    return _prefs?.getBool('onboarding_completed') ?? false;
  }


  // 🔹 Recent Weather Listesi
  static Future<void> saveRecentWeatherList(List<WeatherModel> list) async {
    final jsonList = list.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs?.setStringList('recent_weather', jsonList);
  }

  static List<WeatherModel> getRecentWeatherList() {
    final data = _prefs?.getStringList('recent_weather');
    if (data == null) return [];
    return data.map((e) => WeatherModel.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> addToRecentWeather(WeatherModel model) async {
    List<WeatherModel> list = getRecentWeatherList();

    // Aynı şehir varsa sil
    list.removeWhere((e) => e.cityName == model.cityName);

    // Başına ekle
    list.insert(0, model);

    // En fazla 10 tane
    if (list.length > 10) list = list.sublist(0, 10);

    await saveRecentWeatherList(list);
  }
}
