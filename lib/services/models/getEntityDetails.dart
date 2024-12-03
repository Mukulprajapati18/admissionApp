import 'dart:convert';

class EntityDetailsModel {
  final List<EntityDetail>? entityDetails;

  EntityDetailsModel({
    this.entityDetails,
  });

  factory EntityDetailsModel.fromRawJson(String str) => EntityDetailsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EntityDetailsModel.fromJson(Map<String, dynamic> json) => EntityDetailsModel(
    entityDetails: json["entityDetails"] == null ? [] : List<EntityDetail>.from(json["entityDetails"]!.map((x) => EntityDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "entityDetails": entityDetails == null ? [] : List<dynamic>.from(entityDetails!.map((x) => x.toJson())),
  };
}

class EntityDetail {
  final String? name;
  final String? email;
  final String? country;
  final String? state;
  final String? city;
  final String? address;
  final String? id;
  final String? contact;
  final String? dateTime;

  EntityDetail({
    this.name,
    this.email,
    this.country,
    this.state,
    this.city,
    this.address,
    this.id,
    this.contact,
    this.dateTime,
  });

  factory EntityDetail.fromRawJson(String str) => EntityDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EntityDetail.fromJson(Map<String, dynamic> json) => EntityDetail(
    name: json["name"],
    email: json["email"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    address: json["address"],
    id: json["id"],
    contact: json["contact"],
    dateTime: json["date_time"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "country": country,
    "state": state,
    "city": city,
    "address": address,
    "id": id,
    "contact": contact,
    "date_time": dateTime,
  };
}

