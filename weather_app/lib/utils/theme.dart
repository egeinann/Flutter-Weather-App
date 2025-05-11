import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/constants.dart';

class AppTheme {
  static ThemeData get weatherTheme {
    return ThemeData(
      iconTheme: const IconThemeData(
        color: AppColors.icon,
      ),
      textTheme: TextTheme(
        // *** DEFAULT TEXT STYLES ***
        bodyLarge: TextStyle(
          color: AppColors.textDark,
          fontSize: 18.sp,
          fontFamily: AppFonts.outfit,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textDark,
          fontSize: 16.sp,
          fontFamily: AppFonts.outfit,
          fontWeight: FontWeight.bold,
        ),
        bodySmall: TextStyle(
          color: AppColors.textDark,
          fontSize: 14.sp,
          fontFamily: AppFonts.outfit,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: AppColors.textLight,
          fontSize: 18.sp,
          fontFamily: AppFonts.outfit,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textLight,
          fontSize: 16.sp,
          fontFamily: AppFonts.outfit,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: AppColors.textLight,
          fontSize: 14.sp,
          fontFamily: AppFonts.outfit,
          fontWeight: FontWeight.bold,
        ),

        // *** BIG TEXT STYLES ***
        labelLarge: TextStyle(
          color: AppColors.bigTextDark,
          fontSize: 24.sp,
          fontFamily: AppFonts.outfit,
          fontWeight: FontWeight.bold,
        ),
        labelMedium: TextStyle(
          color: AppColors.bigTextDark,
          fontSize: 22.sp,
          fontFamily: AppFonts.outfit,
          fontWeight: FontWeight.bold,
        ),
        labelSmall: TextStyle(
          color: AppColors.bigTextDark,
          fontSize: 20.sp,
          fontFamily: AppFonts.outfit,
          fontWeight: FontWeight.bold,
        ),
        displayLarge: TextStyle(
          color: AppColors.bigTextLight,
          fontSize: 24.sp,
          fontFamily: AppFonts.outfit,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: AppColors.bigTextLight,
          fontSize: 22.sp,
          fontFamily: AppFonts.outfit,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: AppColors.bigTextLight,
          fontSize: 20.sp,
          fontFamily: AppFonts.outfit,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
