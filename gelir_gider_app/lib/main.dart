import 'package:flutter/material.dart';
import 'package:gelir_gider_app/screens/splash_screen.dart';
import 'package:gelir_gider_app/screens/home_page.dart';
import 'package:gelir_gider_app/utils/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  // Tema tercihini kayıtlı değerden yükle
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
    });
  }

  // Tema değişiminde tercihi kaydet
  Future<void> _saveThemePreference(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', isDark);
  }

  // Tema değiştirme fonksiyonu
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      _saveThemePreference(_isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      isDarkMode: _isDarkMode,
      toggleTheme: _toggleTheme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gelir Gider Takip Uygulaması',
        theme: ThemeProvider.getLightTheme(),
        darkTheme: ThemeProvider.getDarkTheme(),
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (context) => const SplashScreen(routesName: HomeScreen.routeName),
          HomeScreen.routeName: (context) => const HomeScreen(),
        },
      ),
    );
  }
}