import 'package:imc_flutter/exceptions/invalid_height_exception.dart';
import 'package:imc_flutter/exceptions/invalid_name_exception.dart';

class User {
  int? _id;
  String _name = "";
  double _height = 0.0;
  String? _createdAt = "";
  String? updatedAt = "";

  User(this._name, this._height,
      [this._id, this._createdAt = "", this.updatedAt]);

  int get id => _id ?? 0;
  String get name => _name;
  double get height => _height;
  String? get createdAt => _createdAt;

  set name(String name) {
    if (name.length < 3) throw InvalidNameException();
    _name = name;
  }

  set height(double height) {
    if (height <= 0) throw InvalidHeightException();
    _height = height;
  }

  User.fromJson(Map<String, dynamic> json) {
    _id = json["id"];
    _name = json["name"];
    _height = json["height"];
    _createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = _id;
    data["name"] = _name;
    data["height"] = _height;
    data["created_at"] = _createdAt;
    data["updated_at"] = updatedAt;

    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
