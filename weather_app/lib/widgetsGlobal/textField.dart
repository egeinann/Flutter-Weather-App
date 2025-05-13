import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/blocs/citySearch_bloc/city_cubit.dart';
import 'package:weather_app/blocs/citySearch_bloc/city_event.dart';
import 'package:weather_app/blocs/citySearch_bloc/city_state.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/icons.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onCitySelected;
  final VoidCallback onCitySelectedCallback;
  final FocusNode? focusnode;
  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText = 'Enter city...',
    this.onCitySelected,
    required this.onCitySelectedCallback,
    this.focusnode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CityCubit, CityState>(
      builder: (context, state) {
        return Container(
          width: 80.w,
          decoration: BoxDecoration(
            color: AppColors.textLight,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 202, 204, 207),
                blurRadius: 1,
                spreadRadius: 1,
                blurStyle: BlurStyle.inner,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: TypeAheadField<String>(
            controller: controller, // bu artık doğrudan veriliyor
            builder: (context, controller, focusNode) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                cursorColor: AppColors.shadow,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle:
                      Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.icon,
                          ),
                  prefixIcon: const Icon(
                    AppIcons.search,
                    color: AppColors.icon,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      controller.clear();
                      FocusScope.of(context).unfocus();
                    },
                    child: const Icon(
                      AppIcons.close,
                      color: AppColors.icon,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                ),
              );
            },
            suggestionsCallback: (pattern) async {
              final cubit = context.read<CityCubit>();

              if (cubit.allCities.isEmpty) {
                return []; // Liste hala dolmamışsa önerme
              }

              cubit.add(CityTextChanged(pattern));
              await Future.delayed(const Duration(milliseconds: 100));

              final state = cubit.state;
              if (state is CityLoaded) {
                return state.cities; // doğru veriyi döndüğünden emin olun
              } else {
                return [];
              }
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(
                  suggestion,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            },
            onSelected: (suggestion) {
              controller.text = suggestion;
              if (onCitySelected != null) onCitySelected!(suggestion);
              FocusScope.of(context).unfocus();
            },
          ),
        );
      },
    );
  }
}
