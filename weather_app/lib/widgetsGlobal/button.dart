import 'package:flutter/material.dart';
import 'package:weather_app/utils/colors.dart';

Widget customButton({
  required VoidCallback onPressed,
  required Widget child,
  Color backgroundColor = AppColors.button,
  Color textColor = AppColors.textLight,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    child: child,
  );
}

Widget customIconButton({
  required VoidCallback onPressed,
  required IconData icon,
  double size = 25,
  Color backgroundColor = AppColors.button,
  Color textColor = AppColors.icon,
}) {
  return IconButton(
    onPressed: onPressed,
    style: IconButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    iconSize: size,
    icon: Icon(
      icon,
    ),
  );
}