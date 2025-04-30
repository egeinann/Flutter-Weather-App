import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/blocs/weatherBloc/weather_cubit.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/utils/theme.dart';
import 'package:weather_app/view/onboarding/view/onboarding_page.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final WeatherService _weatherService = WeatherService();

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return BlocProvider<WeatherCubit>(
          create: (context) => WeatherCubit(_weatherService),
          child: MaterialApp(
            home: OnboardingPage(), // OnboardingPage burada başlangıç ekranıdır
            debugShowCheckedModeBanner: false,
            theme: AppTheme.weatherTheme, // Uygulama temasını ekledik
          ),
        );
      },
    );
  }
}
