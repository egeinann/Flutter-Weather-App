import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/blocs/weatherBloc/weather_cubit.dart';
import 'package:weather_app/blocs/citySearch_bloc.dart/city_bloc.dart';
import 'package:weather_app/blocs/citySearch_bloc.dart/city_event.dart';
import 'package:weather_app/blocs/citySearch_bloc.dart/city_state.dart';
import 'package:weather_app/blocs/weatherBloc/weather_state.dart';
import 'package:weather_app/utils/image_strings.dart';
import 'package:weather_app/utils/lottie_strings.dart';
import 'package:weather_app/widgets/blur_container.dart';
import 'package:weather_app/widgets/textField.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            backgroundImage(),
            textField(context),
            buildWeather(),
          ],
        ),
      ),
    );
  }

  // *** BUILD WEATHER WIDGET ***
  BlocListener<CityBloc, CityState> buildWeather() {
    return BlocListener<CityBloc, CityState>(
      listener: (context, state) {
        // CityBloc üzerinden gelen şehir verisini alıp WeatherCubit'i tetikleme
        if (state is CityLoaded && state.cities.isNotEmpty) {
          final city = state.cities.first;
          context.read<WeatherCubit>().fetchWeatherForCity(city);
        }
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 90.w,
          height: 70.h,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: customBlurContainer(
            child: Center(
              child: BlocBuilder<WeatherCubit, WeatherState>(
                builder: (context, weatherState) {
                  if (weatherState is WeatherLoading) {
                    return Lottie.asset(LottieFiles.loading);
                  } else if (weatherState is WeatherLoaded) {
                    final weather = weatherState.weatherList.first;
                    return Column(
                      children: [
                        Text(
                          "Şehir: ${weather.cityName}",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        // Sıcaklık: tek haneli ondalıklı formatta olacak
                        Text(
                          "Sıcaklık: ${weather.temperature.toStringAsFixed(1)}°C", // 5.x formatı
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          "Durum: ${weather.description}",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    );
                  } else if (weatherState is WeatherError) {
                    return Text("Hata: ${weatherState.message}");
                  } else {
                    return const Text("Bir şehir arayın...");
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // *** TEXT FIELD INPUT ***
  Padding textField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Text(
              "Şehir Ara",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 5),
            CustomTextField(
              controller: _searchController,
              onCitySelected: (selectedCity) {
                // Seçilen şehir state olarak tutulacak
                context.read<CityBloc>().add(CityTextChanged(selectedCity));
              },
              onCitySelectedCallback: () {
                final city = _searchController.text.trim();
                if (city.isNotEmpty) {
                  context.read<CityBloc>().add(CityTextChanged(city));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // *** BACKGROUND IMAGE ***
  Positioned backgroundImage() {
    return Positioned.fill(
      child: Image.asset(
        BackgroundImages.sunnyBackground,
        fit: BoxFit.cover,
      ),
    );
  }
}
