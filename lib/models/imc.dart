import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:imc_flutter/exceptions/invalid_height_exception.dart';
import 'package:imc_flutter/exceptions/invalid_weight_exception.dart';
import 'package:imc_flutter/shared/colors.dart';

class Imc {
  int? _id;
  String? user;
  double _height = 0.0;
  double _weight = 0.0;
  double _imcValue = 0.0;
  String? measuredAt;
  String? createdAt;
  String? updatedAt;
  int? active;

  Imc(
    this._height,
    this._weight, [
    this.user = "",
    this.measuredAt = "",
    this.createdAt = "",
    this.updatedAt = "",
    this.active = 1,
    this._id,
  ]) {
    _calculateImcValue();
  }

  int get id => _id ?? 0;
  double get height => _height;
  double get weight => _weight;
  double get imcValue => _imcValue;

  set height(double height) {
    if (height <= 0) throw InvalidHeightException();
    _height = height;
    _calculateImcValue();
  }

  set weight(double weight) {
    if (weight <= 0) throw InvalidWeightException();
    _weight = weight;
    _calculateImcValue();
  }

  _calculateImcValue() {
    if (_weight <= 0) throw InvalidWeightException();
    if (_height <= 0) throw InvalidHeightException();

    _imcValue = _weight / math.pow(_height, 2);
  }

  Color get color => _getColor();
  Color _getColor() {
    if (_imcValue == 0.0) return AppColors.primaryClr;
    if (_imcValue < 17.0) return AppColors.underweightColor;
    if (_imcValue < 18.5) return AppColors.lightUnderweightColor;
    if (_imcValue < 25.0) return AppColors.normalWeightColor;
    if (_imcValue < 30.0) return AppColors.overweightColor;
    return AppColors.obesityColor;
  }

  String get classification => _getClassification();
  String _getClassification() {
    if (_imcValue < 16.0) return "Magreza Grave";
    if (_imcValue < 17.0) return "Magreza Moderada";
    if (_imcValue < 18.5) return "Magreza Leve";
    if (_imcValue < 25.0) return "Saudável";
    if (_imcValue < 30.0) return "Sobrepeso";
    if (_imcValue < 35.0) return "Obesidade I";
    if (_imcValue < 40) return "Obesidade II";

    return "Obesidade III";
  }

  Imc.fromJson(Map<String, dynamic> json) {
    _id = json["id"];
    user = json["user"];
    _height = json["height"];
    _weight = json["weight"];
    _imcValue = json["imc_value"] ?? 0;
    measuredAt = json["measured_at"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    active = json["active"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = _id;
    data["user"] = user;
    data["height"] = _height;
    data["weight"] = _weight;
    data["imc_value"] = _imcValue;
    data["measured_at"] = measuredAt;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["active"] = active;

    return data;
  }
}
