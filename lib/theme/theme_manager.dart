import 'package:flutter/material.dart';
import 'package:my_shop/main.dart';


class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class AppThemes {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.softPink,
    scaffoldBackgroundColor:Colors.white,
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
     backgroundColor: AppColors.softPink,
  foregroundColor: AppColors.softTeal,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.softTeal,
      foregroundColor: Colors.white,
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: AppColors.lavenderPurple),
      labelMedium: TextStyle(
        color: AppColors.softTeal, // Selected
        fontWeight: FontWeight.bold,
      ),
      labelSmall: TextStyle(
        color: Colors.black38, // Unselected 
        fontWeight: FontWeight.normal,
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: AppColors.softTeal,
      unselectedLabelColor: Colors.black54,
      indicatorColor: AppColors.softTeal,
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.softPink,
      secondary: AppColors.softTeal,
      surface: AppColors.paleLemon,
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: AppColors.lavenderPurple,
    scaffoldBackgroundColor: Colors.grey[900],
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lavenderPurple,
  foregroundColor: AppColors.softPink,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.softTeal,
      foregroundColor: Colors.black,
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: AppColors.paleLemon),
      labelMedium: TextStyle(
        color: AppColors.paleLemon, // Selected
        fontWeight: FontWeight.bold,
      ),
      labelSmall: TextStyle(
        color: Colors.white, // Unselected
        fontWeight: FontWeight.normal,
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: AppColors.paleLemon,
      unselectedLabelColor: Colors.white54,
      indicatorColor: AppColors.paleLemon,
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColors.lavenderPurple,
      secondary: AppColors.softTeal,
      surface: Colors.grey.shade800,
    ),
  );
}