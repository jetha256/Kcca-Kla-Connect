// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

IncidentType welcomeFromJson(String str) =>
    IncidentType.fromJson(json.decode(str));

String welcomeToJson(IncidentType data) => json.encode(data.toJson());

class IncidentType {
  IncidentType({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<IncidentTypeResult> results;

  factory IncidentType.fromJson(Map<String, dynamic> json) => IncidentType(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<IncidentTypeResult>.from(
            json["results"].map((x) => IncidentTypeResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class IncidentTypeResult {
  IncidentTypeResult({
    required this.id,
    required this.createdOn,
    required this.updatedOn,
    required this.name,
    required this.showIcon,
  });

  String id;
  DateTime createdOn;
  DateTime updatedOn;
  String name;
  String showIcon;

  factory IncidentTypeResult.fromJson(Map<String, dynamic> json) =>
      IncidentTypeResult(
        id: json["id"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedOn: DateTime.parse(json["updated_on"]),
        name: json["name"],
        showIcon: json["show_icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_on": createdOn.toIso8601String(),
        "updated_on": updatedOn.toIso8601String(),
        "name": name,
        "show_icon": showIcon,
      };
}
