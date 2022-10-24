// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

VeirfyOtp welcomeFromJson(String str) => VeirfyOtp.fromJson(json.decode(str));

String welcomeToJson(VeirfyOtp data) => json.encode(data.toJson());

class VeirfyOtp {
  VeirfyOtp({
    required this.verficationId,
    required this.status,
    required this.remarks,
  });

  int verficationId;
  String status;
  String remarks;

  factory VeirfyOtp.fromJson(Map<String, dynamic> json) => VeirfyOtp(
        verficationId: json["verfication_id"],
        status: json["status"],
        remarks: json["remarks"],
      );

  Map<String, dynamic> toJson() => {
        "verfication_id": verficationId,
        "status": status,
        "remarks": remarks,
      };
}
