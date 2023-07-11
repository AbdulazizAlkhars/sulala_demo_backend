import 'dart:convert';
import 'chicken.dart';

class Oviparous {
  final Chicken chicken;

  Oviparous({
    Chicken? chicken,
  }) : chicken = chicken ?? Chicken();

  Map<String, dynamic> toMap() {
    return {
      'chicken': chicken.toMap(),
    };
  }

  factory Oviparous.fromMap(Map<String, dynamic> map) {
    return Oviparous(
      chicken: Chicken.fromMap(map['chicken'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Oviparous.fromJson(String source) =>
      Oviparous.fromMap(json.decode(source) as Map<String, dynamic>);
}
