import 'package:flutter/material.dart';

class TransparentImageContainer extends StatelessWidget {
  final String imagePath;
  final double height;
  final double width;

  const TransparentImageContainer({
    Key? key,
    required this.imagePath,
    this.height = 100,
    this.width = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.fill, // Adjust as needed: cover, contain, etc.
        ),
        color: Colors.transparent,
      ),
    );
  }
}