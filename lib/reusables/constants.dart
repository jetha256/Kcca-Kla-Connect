import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

Gradient scaffoldback = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color.fromRGBO(237, 237, 237, 1),
    Color.fromRGBO(241, 241, 241, 1),
  ],
);

BoxDecoration decorateIt = BoxDecoration(
  gradient: scaffoldback,
);

ServiceStatus? goil = ServiceStatus.enabled;
List<Location>? locations;
