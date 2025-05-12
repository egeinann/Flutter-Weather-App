import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:weather_app/blocs/weatherBloc/weather_cubit.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/icons.dart';
import 'package:weather_app/view/app/home/methods/build_popular_cities.dart';
import 'package:weather_app/view/app/search/search_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Cubit çağrısı burada tetikleniyor
    context.read<WeatherCubit>().fetchWeatherForPopularCities();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: buildPopularCities(),
            ),
            Expanded(
              child: Container(color: Colors.green),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              duration: const Duration(milliseconds: 200),
              type: PageTransitionType.rightToLeft,
              child: SearchPage(),
            ),
          );
        },
        child: Icon(AppIcons.search),
      ),
    );
  }
}
