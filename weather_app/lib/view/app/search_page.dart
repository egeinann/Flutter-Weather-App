import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/blocs/weatherBloc/weather_cubit.dart';
import 'package:weather_app/blocs/citySearch_bloc.dart/city_bloc.dart';
import 'package:weather_app/blocs/citySearch_bloc.dart/city_event.dart';
import 'package:weather_app/blocs/citySearch_bloc.dart/city_state.dart';
import 'package:weather_app/blocs/weatherBloc/weather_state.dart';
import 'package:weather_app/services/city_service.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/utils/image_strings.dart';
import 'package:weather_app/widgets/blur_container.dart';
import 'package:weather_app/widgets/textField.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CityBloc(CityService()),
        ),
        BlocProvider(
          create: (context) => WeatherCubit(WeatherService(), CityService()),
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Image.asset(
                  BackgroundImages.sunnyBackground,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
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
              ),
              BlocListener<CityBloc, CityState>(
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
                              return const CircularProgressIndicator();
                            } else if (weatherState is WeatherLoaded) {
                              final weather = weatherState.weatherList.first;
                              return Column(
                                children: [
                                  Text(
                                    "Şehir: ${weather.cityName}",
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                  Text(
                                    "Sıcaklık: ${weather.temperature}°C",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
