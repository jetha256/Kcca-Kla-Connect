// To parse this JSON data, do
//
//     final newsHistory = newsHistoryFromJson(jsonString);

import 'dart:convert';

NewsHistory newsHistoryFromJson(String str) =>
    NewsHistory.fromJson(json.decode(str));

String newsHistoryToJson(NewsHistory data) => json.encode(data.toJson());

class NewsHistory {
  NewsHistory({
    required this.id,
    required this.name,
    required this.description,
    required this.reporttype,
    required this.reference,
    required this.isemergency,
    required this.address,
    required this.addresslat,
    required this.addresslong,
    required this.attachment,
    required this.createdby,
    required this.datecreated,
    this.dateupdated,
    this.updatedby,
    required this.status,
  });

  String id;
  String name;
  String description;
  String reporttype;
  String reference;
  bool isemergency;
  String address;
  double addresslat;
  double addresslong;
  String attachment;
  String createdby;
  DateTime datecreated;
  dynamic dateupdated;
  dynamic updatedby;
  String status;

  factory NewsHistory.fromJson(Map<String, dynamic> json) => NewsHistory(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        reporttype: json["reporttype"],
        reference: json["reference"],
        isemergency: json["isemergency"],
        address: json["address"],
        addresslat: json["addresslat"].toDouble(),
        addresslong: json["addresslong"].toDouble(),
        attachment: json["attachment"],
        createdby: json["createdby"],
        datecreated: DateTime.parse(json["datecreated"]),
        dateupdated: json["dateupdated"],
        updatedby: json["updatedby"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "reporttype": reporttype,
        "reference": reference,
        "isemergency": isemergency,
        "address": address,
        "addresslat": addresslat,
        "addresslong": addresslong,
        "attachment": attachment,
        "createdby": createdby,
        "datecreated": datecreated.toIso8601String(),
        "dateupdated": dateupdated,
        "updatedby": updatedby,
        "status": status,
      };
}
