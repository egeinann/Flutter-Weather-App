import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/utils/theme.dart';
import 'package:weather_app/view/onboarding/view/onboarding_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          home: OnboardingPage(),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.weatherTheme,
        );
      },
    );
  }
}