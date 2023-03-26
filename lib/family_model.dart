// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';


Family familyFromJson(String str) => Family.fromJson(json.decode(str));

String familyToJson(Family data) => json.encode(data.toJson());

class Family {
  Family({
    this.fullName,
    this.age,
    this.birthdate,
    this.address,
    this.type,
    this.occupation
  });

  String? fullName;
  int? age;
  String? gender;
  String? birthdate;
  String? occupation;
  String? type;
  String? address;

  factory Family.fromJson(Map<String, dynamic> json) => Family(
    fullName: json["fullName"],
    age: json["age"],
    address: json["address"],
    occupation: json["occupation"],
    type: json["type"],
    birthdate: json["birthdate"],
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "age": age,
    "birthdate": birthdate,
    "occupation": occupation,
    "type": type,
  };
}
