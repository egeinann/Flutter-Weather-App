import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/blocs/citySearch_bloc/city_bloc.dart';
import 'package:weather_app/blocs/tabBar_bloc/tab_bloc.dart';
import 'package:weather_app/blocs/weatherBloc/weather_cubit.dart';
import 'package:weather_app/services/city_service.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/utils/theme.dart';
import 'package:weather_app/view/onboarding/view/onboarding_page.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final WeatherService _weatherService = WeatherService();
  final CityService _cityService = CityService();

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<WeatherCubit>(
              create: (context) => WeatherCubit(_weatherService, _cityService),
            ),
            BlocProvider<CityBloc>(
              create: (context) => CityBloc(_cityService),
            ),
            BlocProvider<TabCubit>(
              create: (context) => TabCubit(),
            ),
          ],
          child: SafeArea(
            child: MaterialApp(
              home: OnboardingPage(), // OnboardingPage başlangıç ekranı
              debugShowCheckedModeBanner: false,
              theme: AppTheme.weatherTheme, // Uygulama temasını ekledik
            ),
          ),
        );
      },
    );
  }
}
