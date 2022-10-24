// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';

import 'image_picker_handler.dart';

class ImagePickerDialog extends StatelessWidget {
  final ImagePickerHandler? llistener;
  final AnimationController? ccontroller;
  Animation<double>? drawerContentsOpacity;
  Animation<Offset>? drawerDetailsPosition;
  BuildContext? context;
  ImagePickerDialog(
    ImagePickerListener listener,
    AnimationController controller, {
    Key? key,
    this.llistener,
    this.ccontroller,
    this.drawerContentsOpacity,
    this.drawerDetailsPosition,
    this.context,
  }) : super(key: key);

  void initState() {
    drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(ccontroller!),
      curve: Curves.fastOutSlowIn,
    );
    drawerDetailsPosition = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: ccontroller!,
      curve: Curves.fastOutSlowIn,
    ));
  }

  getImage(BuildContext context) {
    if (ccontroller == null ||
        drawerDetailsPosition == null ||
        drawerContentsOpacity == null) {
      return;
    }
    ccontroller!.forward();
    showDialog(
      context: context,
      builder: (BuildContext context) => SlideTransition(
        position: drawerDetailsPosition!,
        child: FadeTransition(
          opacity: ReverseAnimation(drawerContentsOpacity!),
          child: this,
        ),
      ),
    );
  }

  void dispose() {
    ccontroller!.dispose();
  }

  startTime() async {
    var _duration = const Duration(milliseconds: 200);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context!);
  }

  dismissDialog() {
    ccontroller!.reverse();
    startTime();
  }

  Future<void> getThePics() async {
    llistener!.openCamera();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Material(
        type: MaterialType.transparency,
        child: Opacity(
          opacity: 1.0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                    onTap: () => llistener!.openCamera(),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          )),
                      child: const Center(
                          child: Text(
                        "Camera",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 122, 255, 1),
                            fontSize: 17),
                      )),
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    )),
                const SizedBox(height: 15.0),
                GestureDetector(
                    onTap: () => llistener!.openGallery(),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          )),
                      child: const Center(
                          child: Text(
                        "Gallery",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 122, 255, 1),
                            fontSize: 17),
                      )),
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    )),
                const SizedBox(height: 15.0),
                GestureDetector(
                    onTap: () => dismissDialog(),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          )),
                      child: const Center(
                          child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 122, 255, 1),
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      )),
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    )),
              ],
            ),
          ),
        ));
  }

  Widget roundedButton(
      String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var loginBtn = Container(
      margin: margin,
      padding: const EdgeInsets.all(15.0),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(100.0)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0xFF696969),
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
    return loginBtn;
  }
}
