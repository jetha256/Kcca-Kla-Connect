// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

SignUpModel welcomeFromJson(String str) =>
    SignUpModel.fromJson(json.decode(str));

String welcomeToJson(SignUpModel data) => json.encode(data.toJson());

class SignUpModel {
  SignUpModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.password,
    required this.gender,
    required this.address,
    required this.addresslat,
    required this.addresslong,
    required this.phone,
    required this.mobile,
    required this.photo,
    required this.nin,
    required this.dateofbirth,
    required this.iscitizen,
    required this.isclerk,
    required this.isadmin,
    this.isengineer,
    required this.issuperadmin,
    required this.status,
    required this.datecreated,
    required this.token,
  });

  String id;
  String firstname;
  String lastname;
  String username;
  String email;
  String password;
  String gender;
  String address;
  double addresslat;
  double addresslong;
  String phone;
  String mobile;
  String photo;
  String nin;
  DateTime dateofbirth;
  bool iscitizen;
  bool isclerk;
  bool isadmin;
  bool? isengineer;
  bool issuperadmin;
  String status;
  DateTime datecreated;
  String token;

  factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        gender: json["gender"],
        address: json["address"],
        addresslat: json["addresslat"],
        addresslong: json["addresslong"],
        phone: json["phone"],
        mobile: json["mobile"],
        photo: json["photo"],
        nin: json["nin"],
        dateofbirth: DateTime.parse(json["dateofbirth"]),
        iscitizen: json["iscitizen"],
        isclerk: json["isclerk"],
        isadmin: json["isadmin"],
        isengineer: json["isengineer"],
        issuperadmin: json["issuperadmin"],
        status: json["status"],
        datecreated: DateTime.parse(json["datecreated"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "email": email,
        "password": password,
        "gender": gender,
        "address": address,
        "addresslat": addresslat,
        "addresslong": addresslong,
        "phone": phone,
        "mobile": mobile,
        "photo": photo,
        "nin": nin,
        "dateofbirth":
            "${dateofbirth.year.toString().padLeft(4, '0')}-${dateofbirth.month.toString().padLeft(2, '0')}-${dateofbirth.day.toString().padLeft(2, '0')}",
        "iscitizen": iscitizen,
        "isclerk": isclerk,
        "isadmin": isadmin,
        "isengineer": isengineer,
        "issuperadmin": issuperadmin,
        "status": status,
        "datecreated": datecreated.toIso8601String(),
        "token": token,
      };
}
