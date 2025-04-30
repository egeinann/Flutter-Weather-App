import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:weather_app/services/city_service.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/icons.dart';


class SimpleCityTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onCitySelected;

  const SimpleCityTextField({
    super.key,
    required this.controller,
    this.hintText = 'Şehir ara...',
    this.onCitySelected,
  });

  @override
  _SimpleCityTextFieldState createState() => _SimpleCityTextFieldState();
}

class _SimpleCityTextFieldState extends State<SimpleCityTextField> {
  List<String> cityList = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      decoration: BoxDecoration(
        color: AppColors.container,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 1,
            spreadRadius: 1,
            blurStyle: BlurStyle.inner,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TypeAheadField<String>(
        suggestionsCallback: (pattern) async {
          setState(() {
            isLoading = true;
          });
          try {
            List<String> cities = await fetchCities(pattern);
            setState(() {
              cityList = cities;
              isLoading = false;
            });
            return cityList;
          } catch (e) {
            setState(() {
              isLoading = false;
            });
            return [];
          }
        },
        itemBuilder: (context, String suggestion) {
          return ListTile(
            leading: const Icon(
              AppIcons.city,
              color: AppColors.icon,
            ),
            title:
                Text(suggestion, style: Theme.of(context).textTheme.bodyMedium),
          );
        },
        onSelected: (String suggestion) {
          widget.controller.text = suggestion;
          if (widget.onCitySelected != null) widget.onCitySelected!(suggestion);
        },
        builder: (context, fieldController, focusNode) {
          return TextFormField(
            controller: fieldController,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: const Icon(
                AppIcons.search,
                color: AppColors.icon,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            ),
          );
        },
      ),
    );
  }
}

