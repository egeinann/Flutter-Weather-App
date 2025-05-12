import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/blocs/weatherBloc/weather_cubit.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/icons.dart';
import 'package:weather_app/utils/image_strings.dart';
import 'package:weather_app/view/app/home/methods/build_popular_cities.dart';
import 'package:weather_app/view/app/search/search_page.dart';
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: buildPopularCities(),
            ),
          ),
          customBlurContainer(
            borderRadius: 10,
            x: 20,
            y: 10,
            backgroundColor: AppColors.shadow,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  image: AssetImage(OnboardingImages.welcome_3),
                  fit: BoxFit.scaleDown,
                  height: 25.h,
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: FloatingActionButton(
          heroTag: "hometosearch",
          backgroundColor: AppColors.container,
          splashColor: AppColors.background,
          foregroundColor: AppColors.background,
          elevation: 20,
          shape: CircleBorder(
            side: BorderSide(
              color: AppColors.shadow, // Dış çizgi rengi
              width: 2, // Kalınlık
            ),
          ),
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
      ),
    );
  }
}
