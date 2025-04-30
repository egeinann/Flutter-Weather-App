import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/view/app/home_page.dart';
import 'package:page_transition/page_transition.dart';

class OnboardingBloc extends Cubit<int> {
  OnboardingBloc() : super(0);

  void handlePageChange(int newIndex, BuildContext context) {
    final isLastPage = state == 2;
    final isAttemptingNextPage =
        newIndex == 3; // ConcentricPageView'den gelen geçersiz index

    emit(newIndex.clamp(0, 2)); // Index'i 0-2 arasında sınırla

    if (isLastPage && isAttemptingNextPage) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          PageTransition(
            duration: const Duration(milliseconds: 800),
            type: PageTransitionType.rightToLeft,
            child: const HomePage(),
          ),
        );
      });
    }
  }
}
