import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/blocs/tabBar_bloc/tab_bloc.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/icons.dart';
import 'package:weather_app/view/app/home_page.dart';
import 'package:weather_app/view/app/search_page.dart';
import 'package:weather_app/widgets/blur_container.dart';

class TabBarPage extends StatelessWidget {
  final List<Tab> myTabs = [
    Tab(
      child: Icon(AppIcons.city),
    ),
    Tab(
      child: Icon(AppIcons.search),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            BlocBuilder<TabCubit, int>(
              builder: (context, state) {
                return IndexedStack(
                  index: state,
                  children: [
                    HomePage(),
                    SearchPage(),
                  ],
                );
              },
            ),
            customBlurContainer(
              borderRadius: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        "POPULAR CITIES",
                        style: Theme.of(context).textTheme.labelMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TabBar(
                    dividerColor: Colors.transparent,
                    indicatorColor: AppColors.shadow,
                    indicatorWeight: 5,
                    labelColor: AppColors.shadow,
                    unselectedLabelColor: Colors.grey,
                    physics: const BouncingScrollPhysics(),
                    tabs: myTabs,
                    onTap: (index) {
                      context.read<TabCubit>().changeTab(index);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
