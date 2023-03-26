// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';


Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({
    this.fullName,
    this.age,
    this.gender,
    this.email,
    this.birthdate,
    this.address,
    this.hobby,
    this.skill
  });

  String? fullName;
  int? age;
  String? gender;
  String? email;
  String? skill;
  String? hobby;
  String? address;
  String? birthdate;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    fullName: json["fullName"],
    age: json["age"],
    gender: json["gender"],
    email: json["email"],
    address: json["address"],
    skill: json["skill"],
    hobby: json["hobby"],
    birthdate: json["birthdate"],
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "age": age,
    "gender": gender,
    "email": email,
    "birthdate": birthdate,
    "skill": skill,
    "hobby": hobby,
    "address": address,
  };
}
