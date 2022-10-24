// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Incident welcomeFromJson(String str) => Incident.fromJson(json.decode(str));

String welcomeToJson(Incident data) => json.encode(data.toJson());

class Incident {
  Incident({
    required this.id,
    required this.name,
    required this.description,
    required this.incidentcategoryid,
    required this.incidentcategory,
    required this.address,
    required this.addresslat,
    required this.addresslong,
    required this.isemergency,
    required this.file1,
    required this.file2,
    required this.file3,
    required this.file4,
    required this.file5,
    required this.datecreated,
    required this.createdby,
    this.dateupdated,
    this.updatedby,
    required this.status,
  });

  String id;
  String name;
  String description;
  String incidentcategoryid;
  String incidentcategory;
  String address;
  double addresslat;
  double addresslong;
  bool isemergency;
  String file1;
  String file2;
  String file3;
  String file4;
  String file5;
  DateTime datecreated;
  String createdby;
  dynamic dateupdated;
  dynamic updatedby;
  String status;

  factory Incident.fromJson(Map<String, dynamic> json) => Incident(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        incidentcategoryid: json["incidentcategoryid"],
        incidentcategory: json["incidentcategory"],
        address: json["address"],
        addresslat: json["addresslat"].toDouble(),
        addresslong: json["addresslong"].toDouble(),
        isemergency: json["isemergency"],
        file1: json["file1"],
        file2: json["file2"],
        file3: json["file3"],
        file4: json["file4"],
        file5: json["file5"],
        datecreated: DateTime.parse(json["datecreated"]),
        createdby: json["createdby"],
        dateupdated: json["dateupdated"],
        updatedby: json["updatedby"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "incidentcategoryid": incidentcategoryid,
        "incidentcategory": incidentcategory,
        "address": address,
        "addresslat": addresslat,
        "addresslong": addresslong,
        "isemergency": isemergency,
        "file1": file1,
        "file2": file2,
        "file3": file3,
        "file4": file4,
        "file5": file5,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "dateupdated": dateupdated,
        "updatedby": updatedby,
        "status": status,
      };
}
