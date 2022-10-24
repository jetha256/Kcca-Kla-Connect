// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

SavedLocations welcomeFromJson(String str) =>
    SavedLocations.fromJson(json.decode(str));

String welcomeToJson(SavedLocations data) => json.encode(data.toJson());

class SavedLocations {
  SavedLocations({
    required this.id,
    required this.locationname,
    required this.locationlat,
    required this.locationlong,
    required this.locationaddress,
    required this.datecreated,
    required this.createdby,
    this.dateupdated,
    this.updatedby,
    required this.status,
  });

  String id;
  String locationname;
  double locationlat;
  double locationlong;
  String locationaddress;
  DateTime datecreated;
  String createdby;
  dynamic dateupdated;
  dynamic updatedby;
  String status;

  factory SavedLocations.fromJson(Map<String, dynamic> json) => SavedLocations(
        id: json["id"],
        locationname: json["locationname"],
        locationlat: json["locationlat"].toDouble(),
        locationlong: json["locationlong"].toDouble(),
        locationaddress: json["locationaddress"],
        datecreated: DateTime.parse(json["datecreated"]),
        createdby: json["createdby"],
        dateupdated: json["dateupdated"],
        updatedby: json["updatedby"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "locationname": locationname,
        "locationlat": locationlat,
        "locationlong": locationlong,
        "locationaddress": locationaddress,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "dateupdated": dateupdated,
        "updatedby": updatedby,
        "status": status,
      };
}
