import 'package:flutter/material.dart';
import 'package:gelir_gider_app/screens/splash_screen.dart';
import 'package:gelir_gider_app/screens/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gelir Gider Takip Uygulaması',
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(routesName: HomeScreen.routeName),
        HomeScreen.routeName: (context) => const HomeScreen(),
      },
    );
  }
}
