import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/icons.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller; // Zorunlu hale getirildi


  CustomTextField({
    required this.controller, // Zorunlu parametre olarak tanımlandı
    this.hintText = '... ',

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Bulanıklaştırma
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1), // Yarı saydam arka plan
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  spreadRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              
              controller: controller,
              cursorColor: AppColors.shadow,
              style: Theme.of(context).textTheme.bodyMedium, // Varsayılan beyaz renk
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.shadow), // Varsayılan beyaz renk
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                prefixIcon: Icon(AppIcons.search), // Arama ikonu
                border: InputBorder.none, // Kenarlık yok
              ),
            ),
          ),
        ),
      ),
    );
  }
}
