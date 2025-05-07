import 'package:flutter/material.dart';

import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/widgets/textField.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  String? _selectedCity;
  WeatherModel? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;

  void _fetchWeather(String city) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Hata mesajını sıfırlıyoruz
    });

    try {
      final weather = await WeatherService().fetchWeather(city);
      setState(() {
        _weatherData = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString(); // Hata mesajını set ediyoruz
        _weatherData = null;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $_errorMessage')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Şehir Arama"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Center(
            child: CustomTextField(
              controller: _controller,
              hintText: "Şehir giriniz...",
              onCitySelected: (selectedCity) {
                setState(() {
                  _selectedCity = selectedCity;
                  _controller.text = selectedCity;
                });
                _fetchWeather(selectedCity);
              },
              onCitySelectedCallback: () {
                if (_controller.text.isNotEmpty) {
                  _fetchWeather(_controller.text);
                }
              },
            ),
          ),
          const SizedBox(height: 24),
          _isLoading
              ? const CircularProgressIndicator()
              : _errorMessage != null
                  ? Text(
                      "Hata: $_errorMessage",
                      style: const TextStyle(color: Colors.red),
                    )
                  : _weatherData == null
                      ? const Text("Şehir seçin ve hava durumunu görün")
                      : _buildWeatherInfo(),
        ],
      ),
    );
  }

  Widget _buildWeatherInfo() {
    return Card(
      color: Colors.grey,
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedCity ?? '',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              "${_weatherData!.temperature}°C",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 4),
            Text(
              _weatherData!.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
