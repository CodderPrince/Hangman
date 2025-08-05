import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GifDisplayWidget extends StatelessWidget {
  final String gifPath;
  final double width;
  final double height;

  const GifDisplayWidget({
    super.key,
    required this.gifPath,
    this.width = 200,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      gifPath,
      width: width,
      height: height,
      fit: BoxFit.contain,
    ).animate(
      onComplete: (controller) => controller.repeat(),
    );
  }
}
