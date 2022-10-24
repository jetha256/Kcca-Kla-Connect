// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    required this.id,
    required this.recipient,
    required this.action,
    required this.activityType,
    required this.activity,
    required this.level,
    required this.unread,
    required this.description,
    required this.timestamp,
    required this.public,
    required this.deleted,
    required this.emailed,
    required this.data,
  });

  int id;
  Recipient recipient;
  String action;
  String activityType;
  Activity activity;
  String level;
  bool unread;
  String description;
  DateTime timestamp;
  bool public;
  bool deleted;
  bool emailed;
  String data;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        recipient: Recipient.fromJson(json["recipient"]),
        action: json["action"],
        activityType: json["activity_type"],
        activity: Activity.fromJson(json["activity"]),
        level: json["level"],
        unread: json["unread"],
        description: json["description"],
        timestamp: DateTime.parse(json["timestamp"]),
        public: json["public"],
        deleted: json["deleted"],
        emailed: json["emailed"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "recipient": recipient.toJson(),
        "action": action,
        "activity_type": activityType,
        "activity": activity.toJson(),
        "level": level,
        "unread": unread,
        "description": description,
        "timestamp": timestamp.toIso8601String(),
        "public": public,
        "deleted": deleted,
        "emailed": emailed,
        "data": data,
      };
}

class Activity {
  Activity({
    required this.id,
    required this.village,
    required this.parish,
    required this.division,
    required this.typeDisplay,
    required this.area,
    required this.user,
    required this.viewsCount,
    required this.thumbsUp,
    required this.thumbsDown,
    required this.statusDisplay,
    required this.createdOn,
    required this.updatedOn,
    required this.title,
    required this.description,
    this.attachment,
    required this.ref,
    required this.feedback,
    required this.published,
    required this.priorityDisplay,
    required this.latitude,
    required this.longitude,
    required this.priority,
    required this.subject,
  });

  String id;
  Area village;
  Area parish;
  Area division;
  TypeDisplay typeDisplay;
  Area area;
  Recipient user;
  int viewsCount;
  int thumbsUp;
  int thumbsDown;
  String statusDisplay;
  DateTime createdOn;
  DateTime updatedOn;
  String title;
  String description;
  dynamic attachment;
  String ref;
  String feedback;
  bool published;
  String priorityDisplay;
  String latitude;
  String longitude;
  int priority;
  String subject;

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json["id"],
        village: Area.fromJson(json["village"]),
        parish: Area.fromJson(json["parish"]),
        division: Area.fromJson(json["division"]),
        typeDisplay: TypeDisplay.fromJson(json["type_display"]),
        area: Area.fromJson(json["area"]),
        user: Recipient.fromJson(json["user"]),
        viewsCount: json["views_count"] == null ? null : json["views_count"],
        thumbsUp: json["thumbs_up"] == null ? null : json["thumbs_up"],
        thumbsDown: json["thumbs_down"] == null ? null : json["thumbs_down"],
        statusDisplay: json["status_display"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedOn: DateTime.parse(json["updated_on"]),
        title: json["title"] == null ? null : json["title"],
        description: json["description"],
        attachment: json["attachment"],
        ref: json["ref"],
        feedback: json["feedback"] == null ? null : json["feedback"],
        published: json["published"] == null ? null : json["published"],
        priorityDisplay:
            json["priority_display"] == null ? null : json["priority_display"],
        latitude: json["latitude"] == null ? null : json["latitude"],
        longitude: json["longitude"] == null ? null : json["longitude"],
        priority: json["priority"] == null ? null : json["priority"],
        subject: json["subject"] == null ? null : json["subject"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "village": village.toJson(),
        "parish": parish.toJson(),
        "division": division.toJson(),
        "type_display": typeDisplay.toJson(),
        "area": area.toJson(),
        "user": user.toJson(),
        "views_count": viewsCount == null ? null : viewsCount,
        "thumbs_up": thumbsUp == null ? null : thumbsUp,
        "thumbs_down": thumbsDown == null ? null : thumbsDown,
        "status_display": statusDisplay,
        "created_on": createdOn.toIso8601String(),
        "updated_on": updatedOn.toIso8601String(),
        "title": title == null ? null : title,
        "description": description,
        "attachment": attachment,
        "ref": ref,
        "feedback": feedback == null ? null : feedback,
        "published": published == null ? null : published,
        "priority_display": priorityDisplay == null ? null : priorityDisplay,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "priority": priority == null ? null : priority,
        "subject": subject == null ? null : subject,
      };
}

class Area {
  Area({
    required this.id,
    required this.description,
    required this.name,
  });

  String id;
  String description;
  String name;

  factory Area.fromJson(Map<String, dynamic> json) => Area(
        id: json["id"],
        description: json["description"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "name": name,
      };
}

class TypeDisplay {
  TypeDisplay({
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

  factory TypeDisplay.fromJson(Map<String, dynamic> json) => TypeDisplay(
        id: json["id"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedOn: DateTime.parse(json["updated_on"]),
        name: json["name"],
        showIcon: json["show_icon"] == null ? null : json["show_icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_on": createdOn.toIso8601String(),
        "updated_on": updatedOn.toIso8601String(),
        "name": name,
        "show_icon": showIcon == null ? null : showIcon,
      };
}

class Recipient {
  Recipient({
    required this.id,
    required this.isCitizen,
    required this.isDataEntrant,
    required this.isManager,
    required this.isDdt,
    required this.fullName,
    required this.displayRole,
    // required this.profile,
    required this.incidentsCount,
    required this.lastLogin,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isStaff,
    required this.isActive,
    required this.dateJoined,
    required this.surname,
    required this.gender,
  });

  int id;
  bool isCitizen;
  bool isDataEntrant;
  bool isManager;
  bool isDdt;
  FullName fullName;
  DisplayRole displayRole;
  // Profile profile;
  int incidentsCount;
  DateTime lastLogin;
  Username username;
  FirstName firstName;
  Name lastName;
  Email email;
  bool isStaff;
  bool isActive;
  DateTime dateJoined;
  Name surname;
  Gender gender;

  factory Recipient.fromJson(Map<String, dynamic> json) => Recipient(
        id: json["id"],
        isCitizen: json["is_citizen"],
        isDataEntrant: json["is_data_entrant"],
        isManager: json["is_manager"],
        isDdt: json["is_ddt"],
        fullName: fullNameValues.map[json["full_name"]]!,
        displayRole: displayRoleValues.map[json["display_role"]]!,
        // profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
        incidentsCount:
            json["incidents_count"] == null ? null : json["incidents_count"],
        lastLogin: DateTime.parse(json["last_login"]),
        username: usernameValues.map[json["username"]]!,
        firstName: firstNameValues.map[json["first_name"]]!,
        lastName: nameValues.map[json["last_name"]]!,
        email: emailValues.map[json["email"]]!,
        isStaff: json["is_staff"],
        isActive: json["is_active"],
        dateJoined: DateTime.parse(json["date_joined"]),
        surname: nameValues.map[json["surname"]]!,
        gender: genderValues.map[json["gender"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_citizen": isCitizen,
        "is_data_entrant": isDataEntrant,
        "is_manager": isManager,
        "is_ddt": isDdt,
        "full_name": fullNameValues.reverse[fullName],
        "display_role": displayRoleValues.reverse[displayRole],
        // "profile": profile == null ? null : profile.toJson(),
        "incidents_count": incidentsCount == null ? null : incidentsCount,
        "last_login": lastLogin.toIso8601String(),
        "username": usernameValues.reverse[username],
        "first_name": firstNameValues.reverse[firstName],
        "last_name": nameValues.reverse[lastName],
        "email": emailValues.reverse[email],
        "is_staff": isStaff,
        "is_active": isActive,
        "date_joined": dateJoined.toIso8601String(),
        "surname": nameValues.reverse[surname],
        "gender": genderValues.reverse[gender],
      };
}

enum DisplayRole { DATA_ENTRANT_OFFICER_TRANSPORT, MANAGER_TRANSPORT }

final displayRoleValues = EnumValues({
  "Data Entrant/Officer Transport": DisplayRole.DATA_ENTRANT_OFFICER_TRANSPORT,
  "Manager Transport": DisplayRole.MANAGER_TRANSPORT
});

enum Email { AGNES_KAHWA_GMAIL_COM, AKAHWA_KCCA_GO_UG }

final emailValues = EnumValues({
  "agnes.kahwa@gmail.com": Email.AGNES_KAHWA_GMAIL_COM,
  "akahwa@kcca.go.ug": Email.AKAHWA_KCCA_GO_UG
});

enum FirstName { AGIE, AGNES }

final firstNameValues =
    EnumValues({"Agie": FirstName.AGIE, "Agnes": FirstName.AGNES});

enum FullName { AGIE_ATENYI, AGNES_KAHWA }

final fullNameValues = EnumValues(
    {"Agie Atenyi": FullName.AGIE_ATENYI, "Agnes Kahwa": FullName.AGNES_KAHWA});

enum Gender { FEMALE }

final genderValues = EnumValues({"female": Gender.FEMALE});

enum Name { ATENYI, KAHWA }

final nameValues = EnumValues({"Atenyi": Name.ATENYI, "Kahwa": Name.KAHWA});

class Profile {
  Profile({
    required this.id,
    this.homeAddress,
    this.workAddress,
    required this.createdOn,
    required this.updatedOn,
    required this.nationality,
    required this.nin,
    required this.mobileNumber,
    required this.mobileNumber2,
    required this.headOfDepartment,
    this.address,
    this.dateOfBirth,
    required this.idType,
    required this.idNumber,
    required this.verified,
    required this.division,
    required this.department,
    required this.designation,
    this.language,
  });

  String id;
  dynamic homeAddress;
  dynamic workAddress;
  DateTime createdOn;
  DateTime updatedOn;
  int nationality;
  String nin;
  String mobileNumber;
  String mobileNumber2;
  bool headOfDepartment;
  dynamic address;
  dynamic dateOfBirth;
  String idType;
  String idNumber;
  bool verified;
  String division;
  String department;
  String designation;
  dynamic language;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        homeAddress: json["home_address"],
        workAddress: json["work_address"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedOn: DateTime.parse(json["updated_on"]),
        nationality: json["nationality"] == null ? null : json["nationality"],
        nin: json["nin"],
        mobileNumber: json["mobile_number"],
        mobileNumber2: json["mobile_number_2"],
        headOfDepartment: json["head_of_department"],
        address: json["address"],
        dateOfBirth: json["date_of_birth"],
        idType: json["id_type"] == null ? null : json["id_type"],
        idNumber: json["id_number"] == null ? null : json["id_number"],
        verified: json["verified"],
        division: json["division"],
        department: json["department"],
        designation: json["designation"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "home_address": homeAddress,
        "work_address": workAddress,
        "created_on": createdOn.toIso8601String(),
        "updated_on": updatedOn.toIso8601String(),
        "nationality": nationality == null ? null : nationality,
        "nin": nin,
        "mobile_number": mobileNumber,
        "mobile_number_2": mobileNumber2,
        "head_of_department": headOfDepartment,
        "address": address,
        "date_of_birth": dateOfBirth,
        "id_type": idType == null ? null : idType,
        "id_number": idNumber == null ? null : idNumber,
        "verified": verified,
        "division": division,
        "department": department,
        "designation": designation,
        "language": language,
      };
}

enum Username { AGIEATENYI, AKAHWA }

final usernameValues =
    EnumValues({"agieatenyi": Username.AGIEATENYI, "akahwa": Username.AKAHWA});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
