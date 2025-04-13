import 'package:flutter/material.dart';

class ThemeProvider extends InheritedWidget {
  final bool isDarkMode;
  final Function toggleTheme;

  const ThemeProvider({
    Key? key,
    required this.isDarkMode,
    required this.toggleTheme,
    required Widget child,
  }) : super(key: key, child: child);

  static ThemeProvider of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
    assert(result != null, 'ThemeProvider bulunamadı');
    return result!;
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return isDarkMode != oldWidget.isDarkMode;
  }
  
  // Tema verileri
  static ThemeData getLightTheme() {
    return ThemeData(
      primarySwatch: Colors.indigo,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.grey[100],
      cardColor: Colors.white,
      
    );
  }
  
  static ThemeData getDarkTheme() {
    return ThemeData(
      primarySwatch: Colors.indigo,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
      dividerColor: Colors.white10,
      
    );
  }
}