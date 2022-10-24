import 'package:flutter/material.dart';

class ReuseInput extends StatelessWidget {
  final String? text;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final TextInputAction? action;
  final Widget? last;
  final bool obscureText;
  final callBack;
  const ReuseInput(
      {Key? key,
      this.text,
      this.controller,
      this.textInputType,
      required this.action,
      this.obscureText = false,
      this.callBack,
      this.last})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * .8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TextField(
        textInputAction: action,
        controller: controller,
        keyboardType: textInputType,
        obscureText: obscureText,
        onChanged: callBack,
        decoration: InputDecoration(
          suffixIcon: last,
          contentPadding: const EdgeInsets.all(10.0),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
          hintText: text, // pass the hint text parameter here
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
