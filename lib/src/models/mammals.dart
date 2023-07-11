// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'sheep.dart';

class Mammals {
  final Sheep sheep;

  Mammals({
    Sheep? sheep,
  }) : sheep = sheep ?? Sheep();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sheep': sheep.toMap(),
    };
  }

  factory Mammals.fromMap(Map<String, dynamic> map) {
    return Mammals(
      sheep: Sheep.fromMap(map['sheep'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Mammals.fromJson(String source) =>
      Mammals.fromMap(json.decode(source) as Map<String, dynamic>);
}
