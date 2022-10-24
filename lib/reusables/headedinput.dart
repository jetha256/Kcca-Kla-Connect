import 'package:flutter/material.dart';
import 'package:kcca_kla_connect/reusables/text.dart';

class HeadedInput extends StatelessWidget {
  const HeadedInput(
      {Key? key,
      this.text,
      this.fWeight,
      this.color,
      this.size,
      this.fStyle,
      this.icons,
      this.iconsize,
      this.iconcolor,
      this.controller,
      this.textInputType,
      this.action,
      this.textt,
      this.circleon,
      this.hintcolor})
      : super(key: key);
  final String? text;
  final FontWeight? fWeight;
  final Color? color;
  final double? size;
  final FontStyle? fStyle;
  final IconData? icons;
  final double? iconsize;
  final Color? iconcolor;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final TextInputAction? action;
  final String? textt;
  final bool? circleon;
  final Color? hintcolor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        children: [
          ListTile(
            dense: true,
            leading: Icon(
              icons,
              size: iconsize,
              color: iconcolor,
            ),
            title: ReuseText(
              text: text,
              color: color,
              size: size,
              textAlign: TextAlign.start,
              fWeight: fWeight,
              fStyle: fStyle,
            ),
            subtitle: ReuseText(
              text: textt,
              color: hintcolor,
              size: size,
              fWeight: fWeight,
              textAlign: TextAlign.start,
              fStyle: fStyle,
            ),
            // trailing: const Spacer(),
          ),
          const Divider(
            thickness: 2,
          )
        ],
      ),
    );
  }
}
