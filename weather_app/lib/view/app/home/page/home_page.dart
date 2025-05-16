import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/blocs/weatherBloc/weather_cubit.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/image_strings.dart';
import 'package:weather_app/view/app/home/methods/build_popular_cities.dart';
import 'package:weather_app/view/app/home/methods/floating_button.dart';
import 'package:weather_app/widgetsGlobal/blur_container.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Cubit çağrısı burada tetikleniyor
    context.read<WeatherCubit>().fetchWeatherForPopularCities();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          buildPopularCities(),
          customBlurContainer(
            height: 30.h,
            borderRadius: 10,
            x: 20,
            y: 10,
            backgroundColor: AppColors.shadow,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Image(
                    image: AssetImage(OnboardingImages.welcome_3),
                    fit: BoxFit.scaleDown,
                                
                  ),
                ),
                Text(
                  "Hello Weatherly!",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(height: 5),
                Divider(
                  endIndent: 30.w,
                  indent: 30.w,
                  color: AppColors.shadow,
                  thickness: 2,
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: floatingButton(context),
    );
  }
}
