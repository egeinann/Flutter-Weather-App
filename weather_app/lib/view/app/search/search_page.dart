import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/utils/icons.dart';
import 'package:weather_app/widgetsGlobal/button.dart';
import 'package:weather_app/widgetsGlobal/shimmer.dart';
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
  List<WeatherModel> recentWeatherData = [];

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

  // *** GİRİLEN ŞEHİR İÇİN HAVA DURUMUNU ÇEK ***
  void _fetchWeather(String city) async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await WeatherService().fetchWeather(city);
      setState(() {
        _weatherData = weather;
        _isLoading = false;

        // Şehri listeye ekle
        if (!recentWeatherData.any((w) => w.cityName == city)) {
          recentWeatherData.insert(0, weather);
          if (recentWeatherData.length > 10) {
            recentWeatherData = recentWeatherData.sublist(0, 10);
          }
        }
      });
      _controllerAnim.reset();
      _controllerAnim.forward();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.topCenter,
                child: textField(),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: _isLoading
                  ? SizedBox()
                  : _errorMessage != null
                      ? Text(
                          "Hata: $_errorMessage",
                          style: const TextStyle(color: Colors.red),
                        )
                      : _weatherData == null
                          ? const Text("Enter city")
                          : SlideTransition(
                              position: _slideAnimation,
                              child: buildWeatherCard(),
                            ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: customButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => buildRecentCitiesSheet(),
                    );
                  },
                  child: Icon(AppIcons.history),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // *** TEXTFIELD ***
  CustomTextField textField() {
    return CustomTextField(
      controller: _controller,
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

  // *** ARATILAN ŞEHİR ANLIK ***
  Widget buildWeatherCard() {
    return Container(
      height: 30.h,
      width: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background image with shimmer
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: _weatherData!.backgroundImage,
                fit: BoxFit.cover,
                placeholder: (context, url) => customShimmer(
                  Container(color: Colors.grey[300]),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey,
                  child: const Icon(Icons.error, color: Colors.white),
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customShimmer(
                          Text(
                            "${_weatherData!.country} - ${_weatherData!.cityName}",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                        customShimmer(
                          Text(
                            "${_weatherData!.temperature}°C",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadiusDirectional.only(
                        bottomEnd: Radius.circular(20),
                        bottomStart: Radius.circular(20),
                        topEnd: Radius.circular(100),
                        topStart: Radius.circular(100),
                      ),
                      color: _weatherData!.backgroundColor.withOpacity(0.6),
                    ),
                    child: Center(
                      child: customShimmer(
                        Text(
                          _weatherData!.description,
                          style: Theme.of(context).textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Icon için Cached + shimmer
            CachedNetworkImage(
              imageUrl: _weatherData!.iconAsset,
              height: 10.h,
              fit: BoxFit.cover,
              placeholder: (context, url) => customShimmer(
                SizedBox(
                  height: 10.h,
                  width: 10.h,
                  child: Container(color: Colors.grey[300]),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ],
        ),
      ),
    );
  }

  // *** GEÇMİŞTE ARATILAN ŞEHİRLER ***
  Widget buildRecentCitiesSheet() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Last searched cities",
              style: Theme.of(context).textTheme.headlineSmall),
          ...recentWeatherData.map(
            (weather) => ListTile(
              title: Text(weather.cityName),
              subtitle: Text(weather.description),
              trailing: Text(
                "${weather.temperature}°C",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
                _controller.text = weather.cityName;
                _fetchWeather(weather.cityName);
              },
            ),
          ),
        ],
      ),
    );
  }
}
