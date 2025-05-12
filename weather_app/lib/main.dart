import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/blocs/citySearch_bloc/city_cubit.dart';
import 'package:weather_app/blocs/weatherBloc/weather_cubit.dart';
import 'package:weather_app/services/city_service.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/utils/theme.dart';
import 'package:weather_app/view/app/home/page/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
              home: HomePage(),
              debugShowCheckedModeBanner: false,
              theme: AppTheme.weatherTheme,
            ),
          ),
        );
      },
    );
  }
}
