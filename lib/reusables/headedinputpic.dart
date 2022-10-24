import 'package:flutter/material.dart';
import 'package:kcca_kla_connect/reusables/text.dart';

class HeadedInputPic extends StatelessWidget {
  const HeadedInputPic(
      {Key? key,
      this.text,
      this.fWeight,
      this.color,
      this.size,
      this.fStyle,
      this.imageString,
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
  final String? imageString;
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
        horizontal: 20,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListTile(
              dense: true,
              leading: Image.asset(imageString!),
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
              trailing: const Spacer(),
            ),
          ),
          const Divider(
            thickness: 2,
          )
        ],
      ),
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     const SizedBox(
      //       height: 20,
      //     ),
      //     Row(
      //       children: [
      //         Icon(
      //           icons,
      //           size: iconsize,
      //           color: iconcolor,
      //         ),
      //         const SizedBox(
      //           width: 15,
      //         ),
      //         ReuseText(
      //           text: text,
      //           color: color,
      //           size: size,
      //           fWeight: fWeight,
      //           fStyle: fStyle,
      //         ),
      //       ],
      //     ),
      //     TextField(
      //       textInputAction: action,
      //       controller: controller,
      //       keyboardType: textInputType,
      //       decoration: InputDecoration(
      //         contentPadding: const EdgeInsets.all(10.0),
      //         hintText: textt, // pass the hint text parameter here
      //         hintStyle: TextStyle(color: hintcolor),
      //       ),
      //       style: const TextStyle(color: Colors.black),
      //     )
      //   ],
      // ),
    );
  }
}

class HeadedInputCard extends StatelessWidget {
  const HeadedInputCard(
      {Key? key,
      this.text,
      this.fWeight,
      this.color,
      this.size,
      this.fStyle,
      this.imageString,
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
  final String? imageString;
  final Color? iconcolor;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final TextInputAction? action;
  final String? textt;
  final bool? circleon;
  final Color? hintcolor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 90,
        width: 78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: Color.fromRGBO(237, 30, 36, 1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              imageString!,
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width * .1,
              height: MediaQuery.of(context).size.width * .1,
            ),
            ReuseText(
              text: text,
              color: color,
              size: size,
              textAlign: TextAlign.center,
              fWeight: fWeight,
              fStyle: fStyle,
            ),
            textt != ''
                ? ReuseText(
                    text: textt,
                    color: color,
                    size: size,
                    textAlign: TextAlign.center,
                    fWeight: fWeight,
                    fStyle: fStyle,
                  )
                : SizedBox(
                    height: 0,
                    width: 0,
                  ),
          ],
        ),
      ),
    );
  }
}
