import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';

class Secrets {
  // Add your Google Maps API Key here
  static const API_KEY = 'AIzaSyAUUB90GqPuBRE3ZtnJVwZa4YAWInQXBGY';
}

List<Location>? startPlacemark;
List<Location>? destinationPlacemark;

TravelMode peel = TravelMode.transit;
