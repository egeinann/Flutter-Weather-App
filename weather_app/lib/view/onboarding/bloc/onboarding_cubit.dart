import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:weather_app/data/sharedPref.dart';
import 'package:weather_app/view/app/home/page/home_page.dart';

class OnboardingBloc extends Cubit<int> {
  OnboardingBloc() : super(0);

  void handlePageChange(int newIndex, BuildContext context) {
    final isLastPage = state == 2;
    final isAttemptingNextPage = newIndex == 3;
    emit(newIndex.clamp(0, 2)); // Index 0-2 arasında sınırla

    if (isLastPage && isAttemptingNextPage) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () async {
          Navigator.pushReplacement(
            context,
            PageTransition(
              duration: const Duration(milliseconds: 500),
              type: PageTransitionType.rightToLeft,
              child: HomePage(),
            ),
          );
          await SharedPreferencesService.setOnboardingCompleted(true);
          print("onboarding geçildi!!!");
        },
      );
    }
  }
}
