import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/image_strings.dart';
import 'package:weather_app/utils/lottie_strings.dart';
import 'package:weather_app/view/onboarding/bloc/onboarding_cubit.dart';
import 'package:weather_app/view/onboarding/model/onboarding_model.dart';
import 'package:weather_app/widgetsGlobal/shadow_container.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});
  final ValueNotifier<int> pageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final List<Onboarding> pages = [
      Onboarding(
        title: "Welcome to Weatherly!",
        widget: customShadowContainer(
          height: 30.h,
          width: 90.w,
          child: Lottie.network(LottieFiles.downtown, fit: BoxFit.cover),
        ),
        color: Colors.transparent,
      ),
      Onboarding(
        title: "Real-time Weather Updates",
        widget:
            Image.network(IconImages.onboardingImage, fit: BoxFit.scaleDown),
        color: AppColors.container,
      ),
      Onboarding(
        title: "Let's get started!",
        widget: customShadowContainer(
          height: 30.h,
          width: 90.w,
          child:
              Lottie.network(LottieFiles.partlycloudy, fit: BoxFit.scaleDown),
        ),
        color: AppColors.background,
      ),
    ];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocProvider(
        create: (_) => OnboardingBloc(),
        child: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/background.png",
                  fit: BoxFit.cover,
                ),
              ),
              BlocBuilder<OnboardingBloc, int>(
                builder: (context, currentIndex) {
                  return ConcentricPageView(
                    duration: const Duration(milliseconds: 600),
                    physics: const BouncingScrollPhysics(),
                    itemCount: pages.length + 1,
                    onChange: (index) {
                      context
                          .read<OnboardingBloc>()
                          .handlePageChange(index, context);
                      pageNotifier.value = index.clamp(0, 2);
                    },
                    radius: 205,
                    scaleFactor: 1,
                    curve: Curves.easeInOutCubic,
                    itemBuilder: (index) => index < pages.length
                        ? _buildPage(pages[index], context)
                        : const SizedBox(),
                    colors: pages.map((p) => p.color).toList(),
                  );
                },
              ),

              // SmoothPageIndicator
              Positioned(
                bottom: 60,
                left: 0,
                right: 0,
                child: ValueListenableBuilder<int>(
                  valueListenable: pageNotifier,
                  builder: (context, value, child) {
                    return Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: value,
                        count: pages.length,
                        effect: JumpingDotEffect(
                          dotHeight: 10,
                          dotWidth: 20,
                          jumpScale: 2,
                          activeDotColor: AppColors.shadow,
                          dotColor: AppColors.button.withOpacity(0.3),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(Onboarding page, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            page.title,
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          page.widget,
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
