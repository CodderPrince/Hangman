import 'package:flutter/material.dart';

class ScreenLayout extends StatelessWidget {
  final Widget child;
  final Color startColor;
  final Color endColor;
  final bool isHomeScreen;


  const ScreenLayout({super.key, required this.child, required this.startColor, required this.endColor, this.isHomeScreen = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [startColor, endColor],
          ),
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}