// *** button ***
  import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/icons.dart';
import 'package:weather_app/view/app/search/search_page.dart';

Padding floatingButton(BuildContext context) {
    return Padding(
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
              type: PageTransitionType.sharedAxisVertical,
              child: SearchPage(),
            ),
          );
        },
        child: Icon(AppIcons.search),
      ),
    );
  }