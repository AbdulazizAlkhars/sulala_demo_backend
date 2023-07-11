// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'mammals.dart';
import 'oviparous.dart';

class FarmAnimals {
  final String name;
  final DateTime createdDate;
  final String userId;
  final Mammals mammals;
  final Oviparous oviparous;

  FarmAnimals({
    this.name = '',
    DateTime? createdDate,
    String? userId,
    Mammals? mammals,
    Oviparous? oviparous,
  })  : createdDate = createdDate ?? DateTime.now(),
        userId = userId ?? '',
        mammals = mammals ?? Mammals(),
        oviparous = oviparous ?? Oviparous();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'createdDate': createdDate.toIso8601String(),
      'userId': userId,
      'mammals': mammals.toMap(),
      'oviparous': oviparous.toMap(),
    };
  }

  factory FarmAnimals.fromMap(Map<String, dynamic> map,
      {DateTime? createdDate}) {
    return FarmAnimals(
      name: map['name'] as String,
      createdDate: createdDate ?? DateTime.now(),
      userId: map['userId'] as String,
      mammals: Mammals.fromMap(map['mammals'] as Map<String, dynamic>),
      oviparous: Oviparous.fromMap(map['oviparous'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory FarmAnimals.fromJson(String source) =>
      FarmAnimals.fromMap(json.decode(source) as Map<String, dynamic>);
}
