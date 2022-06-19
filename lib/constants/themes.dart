import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

LottieBuilder loadingIcon = Lottie.asset('assets/load.json',width: 200);

class AppColors {
  static Color primaryColor = Color(0xFF554149);
  static Color greyColor = Color(0xFFDDD7C6);
  static Color white = Colors.white;
}

class Themes {
  static ThemeData light = ThemeData(
    primaryColor: AppColors.primaryColor,
    primaryColorLight: AppColors.primaryColor,
    appBarTheme: AppBarTheme(backgroundColor: AppColors.primaryColor),
    iconTheme: IconThemeData(color: AppColors.primaryColor),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primaryColor,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      bodySmall: TextStyle(fontSize: 16, color: Colors.black),
    ),
  ).copyWith();
}
