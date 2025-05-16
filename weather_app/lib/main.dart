import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/blocs/citySearch_bloc/city_cubit.dart';
import 'package:weather_app/blocs/weatherBloc/weather_cubit.dart';
import 'package:weather_app/data/sharedPref.dart';
import 'package:weather_app/servicesAPI/city_service.dart';
import 'package:weather_app/servicesAPI/weather_service.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/icons.dart';
import 'package:weather_app/utils/theme.dart';
import 'package:weather_app/view/app/home/page/home_page.dart';
import 'package:weather_app/view/onboarding/view/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();
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
              create: (context) => WeatherCubit(_weatherService),
            ),
            BlocProvider<CityCubit>(
              create: (context) => CityCubit(_cityService),
            ),
          ],
          child: SafeArea(
            child: MaterialApp(
              home: whichPage(),
              debugShowCheckedModeBanner: false,
              theme: AppTheme.weatherTheme,
            ),
          ),
        );
      },
    );
  }

  // *** hangi ekran önce başlasın ONBOARDİNG/HOME ***
  FutureBuilder<bool> whichPage() {
    return FutureBuilder<bool>(
      future: Future.value(SharedPreferencesService.getOnboardingCompleted()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Icon(
                AppIcons.cloud,
                color: AppColors.container,
              ),
            ),
          );
        } else {
          final onboardingCompleted = snapshot.data ?? false;
          return onboardingCompleted ? HomePage() : OnboardingPage();
        }
      },
    );
  }
}
