import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/blocs/tabBar_bloc/tab_bloc.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/icons.dart';
import 'package:weather_app/view/app/home/page/home_page.dart';
import 'package:weather_app/view/app/search/search_page.dart';
import 'package:weather_app/widgetsGlobal/shadow_container.dart';

class TabBarPage extends StatelessWidget {
  final List<Tab> myTabs = [
    Tab(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(AppIcons.city),
        Text(
          'City', // Etiket
          style: TextStyle(
            color: Colors.white, // Etiket rengini istediğiniz gibi ayarlayabilirsiniz
            fontSize: 12,
          ),
        ),
      ],
    ),
  ),
  Tab(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(AppIcons.search),
        Text(
          'Search', // Etiket
          style: TextStyle(
            color: Colors.black, // Etiket rengini istediğiniz gibi ayarlayabilirsiniz
            fontSize: 12,
          ),
        ),
      ],
    ),
  ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          scrolledUnderElevation: 0,
          centerTitle: true,
          backgroundColor: AppColors.background,
          title: customShadowContainer(
            height: 70,
            width: 95.w,
            backgroundColor: AppColors.textLight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TabBar(
                
                  dividerColor: Colors.transparent,
                  indicator:
                      BoxDecoration(), // Kaldırıyoruz, animasyonla göstereceğiz
                  tabs: List.generate(myTabs.length, (index) {
                    final isSelected = context.watch<TabCubit>().state == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.shadow
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        index == 0 ? AppIcons.city : AppIcons.search,
                        color: isSelected ? AppColors.icon : AppColors.shadow,
                      ),
                    );
                  }),
                  onTap: (index) {
                    context.read<TabCubit>().changeTab(index);
                  },
                ),
              ],
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
