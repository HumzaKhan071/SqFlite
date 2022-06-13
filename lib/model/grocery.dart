import 'package:flutter/foundation.dart';

class Grocery {
  late final int? id;
  late final String name;

  Grocery({this.id, required this.name});

  factory Grocery.fromMap(Map<String, dynamic> json) => new Grocery(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name};
  }
}
