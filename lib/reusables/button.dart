import 'package:flutter/material.dart';

class ReuseButton extends StatelessWidget {
  const ReuseButton(
      {Key? key, this.height, this.width, this.radius, this.color, this.child})
      : super(key: key);
  final double? height;
  final double? width;
  final double? radius;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius!),
        color: color,
      ),
      child: Center(child: child),
    );
  }
}
