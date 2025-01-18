import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color startColor;
  final Color endColor;

  const StyledButton({super.key, required this.text, required this.onPressed, required this.startColor,
    required this.endColor,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 300,
        height: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white, width: 2),
            gradient: LinearGradient(colors: [startColor, endColor]),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                offset: Offset(0, 3),
              )
            ]),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 24, fontFamily: 'Arial', color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class SmallStyledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color startColor;
  final Color endColor;
  const SmallStyledButton({super.key, required this.text, required this.onPressed, required this.startColor,
    required this.endColor,});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 95,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white, width: 2),
            gradient: LinearGradient(colors: [startColor, endColor]),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                offset: Offset(0, 3),
              )
            ]),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 18, fontFamily: 'Arial', color: Colors.white),
          ),
        ),
      ),
    );
  }
}