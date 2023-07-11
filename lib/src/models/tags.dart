// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// lib/src/models/tags.dart
class Tags {
  final List<String> currentState;
  final List<String> medicalState;
  final List<String> other;

  Tags({
    this.currentState = const [],
    this.medicalState = const [],
    this.other = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'currentState': currentState,
      'medicalState': medicalState,
      'other': other,
    };
  }

  factory Tags.fromMap(Map<String, dynamic> map) {
    return Tags(
      currentState: List<String>.from(map['currentState'] as List),
      medicalState: List<String>.from(map['medicalState'] as List),
      other: List<String>.from(map['other'] as List),
    );
  }

  String toJson() => json.encode(toMap());

  factory Tags.fromJson(String source) =>
      Tags.fromMap(json.decode(source) as Map<String, dynamic>);
}
