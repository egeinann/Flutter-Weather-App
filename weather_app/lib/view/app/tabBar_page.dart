import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/blocs/tabBar_bloc/tab_bloc.dart';
import 'package:weather_app/view/app/home_page.dart';
import 'package:weather_app/view/app/search_page.dart';

class TabBarPage extends StatelessWidget {
  final List<Tab> myTabs = const [
    Tab(text: 'Tab 1'),
    Tab(text: 'Tab 2'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('TabBar Bloc'),
          bottom: TabBar(
            tabs: myTabs,
            onTap: (index) {
              context.read<TabCubit>().changeTab(index);
            },
          ),
        ),
        body: BlocBuilder<TabCubit, int>(
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
      ),
    );
  }
}
