import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReuseText extends StatelessWidget {
  final String? text;
  final FontWeight? fWeight;
  final Color? color;
  final double? size;
  final FontStyle? fStyle;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const ReuseText({
    Key? key,
    this.text,
    this.fWeight,
    this.color,
    this.size,
    this.fStyle,
    this.textAlign = TextAlign.center,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      maxLines: 5,
      textAlign: textAlign,
      style: GoogleFonts.lato(
        textStyle: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: fWeight,
          fontStyle: fStyle,
        ),
      ),
    );
  }
}
