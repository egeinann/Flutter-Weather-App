import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/blocs/citySearch_bloc.dart/city_bloc.dart';
import 'package:weather_app/services/city_service.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/icons.dart';
import 'package:weather_app/utils/lottie_strings.dart';
import 'package:weather_app/view/onboarding/bloc/onboarding_cubit.dart';
import 'package:weather_app/view/onboarding/model/onboarding_model.dart';
import 'package:weather_app/widgets/shadow_container.dart';
import 'package:weather_app/widgets/textField.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final List<Onboarding> pages = [
      Onboarding(
        title: "Welcome",
        widget: customShadowContainer(
          child: Lottie.asset(LottieFiles.downtown, fit: BoxFit.cover),
        ),
        color: WeatherColors.cloudy,
      ),
      Onboarding(
        title: "Current weather information!",
        widget: Lottie.asset(LottieFiles.thunder, fit: BoxFit.cover),
        color: WeatherColors.stormy,
      ),
      Onboarding(
        title: "How is the weather today?",
        widget: BlocProvider(
          create: (_) => CityBloc(CityService()),
          child: CustomTextField(
            onCitySelectedCallback: () {
              print("tıklandı");
            },
            controller: _controller,
            onCitySelected: (city) {
              // seçilen şehir ile işlem yapılacaksa
            },
          ),
        ),
        color: WeatherColors.cloudy,
      ),
    ];
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocProvider(
        create: (context) => OnboardingBloc(),
        child: Scaffold(
          body: Stack(
            children: [
              BlocBuilder<OnboardingBloc, int>(
                builder: (context, currentIndex) {
                  return ConcentricPageView(
                    duration: const Duration(milliseconds: 500),
                    physics: const BouncingScrollPhysics(),
                    itemCount: pages.length + 1,
                    itemBuilder: (index) => index < pages.length
                        ? _buildPage(pages[index], context)
                        : const SizedBox(), // Boş widget
                    onChange: (index) {
                      context
                          .read<OnboardingBloc>()
                          .handlePageChange(index, context);
                    },
                    radius: 300,
                    colors: pages.map((p) => p.color).toList(),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Icon(
                    AppIcons.right,
                    size: 50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sayfa yapısı
  Widget _buildPage(Onboarding page, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          page.widget,
          const SizedBox(height: 20),
          Text(
            page.title,
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
