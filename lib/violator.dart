import 'package:flutter/widgets.dart';

class Violator {
  int? id;
  String? name;
  String? mobileNumber;

  Violator({this.id, required this.name, required this.mobileNumber});

  factory Violator.fromJson(Map<String, dynamic> json) => Violator(
      id: json['id'], name: json['name'], mobileNumber: json['mobileNumber']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mobileNumber': mobileNumber,
      };
}
