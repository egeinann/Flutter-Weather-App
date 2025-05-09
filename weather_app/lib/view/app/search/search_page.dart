import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/widgetsGlobal/blur_container.dart';
import 'package:weather_app/widgetsGlobal/textField.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  String? _selectedCity;
  WeatherModel? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _controllerAnim;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controllerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _controllerAnim,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _controllerAnim.dispose();
    _controller.dispose();
    super.dispose();
  }

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
      _controllerAnim.reset(); // Animasyonu sıfırlıyoruz
      _controllerAnim.forward(); // Animasyonu başlatıyoruz
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
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: textField(),
          ),
          Align(
            alignment: Alignment.center,
            child: _isLoading
                ? buildShimmerEffect()
                : _errorMessage != null
                    ? Text(
                        "Hata: $_errorMessage",
                        style: const TextStyle(color: Colors.red),
                      )
                    : _weatherData == null
                        ? const Text("Şehir seçin ve hava durumunu görün")
                        : SlideTransition(
                            position: _slideAnimation,
                            child: buildWeatherCard(),
                          ),
          ),
        ],
      ),
    );
  }

  CustomTextField textField() {
    return CustomTextField(
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
    );
  }

  Widget buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 20,
              width: 150,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Container(
              height: 30,
              width: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 4),
            Container(
              height: 15,
              width: 200,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWeatherCard() {
    return customBlurContainer(
      backgroundColor: Colors.red,
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
