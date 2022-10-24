// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

UserModel welcomeFromJson(String str) => UserModel.fromJson(json.decode(str));

String welcomeToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.userid,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.gender,
    required this.phone,
    required this.mobile,
    required this.address,
    required this.addresslat,
    required this.addresslong,
    required this.nin,
    required this.dateofbirth,
    required this.photo,
    required this.isadmin,
    required this.issuperadmin,
    required this.isclerk,
    required this.iscitizen,
    this.isengineer,
    this.roleid,
    required this.datecreated,
    required this.incidentscount,
    required this.token,
    required this.status,
  });

  String userid;
  String firstname;
  String lastname;
  String username;
  String email;
  String gender;
  String phone;
  String mobile;
  String address;
  double addresslat;
  double addresslong;
  String nin;
  DateTime dateofbirth;
  String photo;
  bool isadmin;
  bool issuperadmin;
  bool isclerk;
  bool iscitizen;
  bool? isengineer;
  dynamic roleid;
  DateTime datecreated;
  int incidentscount;
  String token;
  String status;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userid: json["userid"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        email: json["email"],
        gender: json["gender"],
        phone: json["phone"],
        mobile: json["mobile"],
        address: json["address"],
        addresslat: json["addresslat"].toDouble(),
        addresslong: json["addresslong"].toDouble(),
        nin: json["nin"],
        dateofbirth: DateTime.parse(json["dateofbirth"]),
        photo: json["photo"],
        isadmin: json["isadmin"],
        issuperadmin: json["issuperadmin"],
        isclerk: json["isclerk"],
        iscitizen: json["iscitizen"],
        isengineer: json["isengineer"],
        roleid: json["roleid"],
        datecreated: DateTime.parse(json["datecreated"]),
        incidentscount: json["incidentscount"],
        token: json["token"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "email": email,
        "gender": gender,
        "phone": phone,
        "mobile": mobile,
        "address": address,
        "addresslat": addresslat,
        "addresslong": addresslong,
        "nin": nin,
        "dateofbirth": dateofbirth.toIso8601String(),
        "photo": photo,
        "isadmin": isadmin,
        "issuperadmin": issuperadmin,
        "isclerk": isclerk,
        "iscitizen": iscitizen,
        "isengineer": isengineer,
        "roleid": roleid,
        "datecreated": datecreated.toIso8601String(),
        "incidentscount": incidentscount,
        "token": token,
        "status": status,
      };
}
