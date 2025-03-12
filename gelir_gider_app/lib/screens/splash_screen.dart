import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash_screen';
  final String routesName;

  const SplashScreen({super.key, required this.routesName});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushNamed(context, widget.routesName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.purple],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(
              height: 75,
              width: 75,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                strokeWidth: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
