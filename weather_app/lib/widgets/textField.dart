import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/blocs/citySearch_bloc.dart/city_bloc.dart';
import 'package:weather_app/blocs/citySearch_bloc.dart/city_event.dart';
import 'package:weather_app/blocs/citySearch_bloc.dart/city_state.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/icons.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onCitySelected;
  final VoidCallback onCitySelectedCallback;
  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText = 'Enter city...',
    this.onCitySelected,
    required this.onCitySelectedCallback,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CityBloc, CityState>(
      builder: (context, state) {
        return Container(
          width: 80.w,
          decoration: BoxDecoration(
            color: AppColors.container,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
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
                  prefixIcon: const Icon(
                    AppIcons.search,
                    color: AppColors.icon,
                  ),
                  suffixIcon: _buildSuffixIcon(context),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                ),
              );
            },
            suggestionsCallback: (pattern) async {
              context.read<CityBloc>().add(CityTextChanged(pattern));
              await Future.delayed(const Duration(milliseconds: 100));
              final state = context.read<CityBloc>().state;
              if (state is CityLoaded) {
                return state.cities;
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

  Widget _buildSuffixIcon(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onCitySelectedCallback,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(AppIcons.right, color: AppColors.icon),
        ),
      ),
    );
  }
}
