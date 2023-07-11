// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'tags.dart';

class Sheep {
  final String id;
  final DateTime dob;
  final String name;
  final String breed;
  final String image;
  final String sex;
  final List<Sheep> parents;
  final List<Sheep> children;
  final Tags tags;
  final String notes;
  final Map<String, String> customFields;
  final List<String> uploadedFiles;
  final DateTime dateOfMate;
  final DateTime dateOfDeadOrSell;
  final DateTime dateOfWeaning;
  final String breedingStage;

  Sheep({
    this.id = '',
    DateTime? dob,
    this.name = '',
    this.breed = '',
    this.image = '',
    this.sex = '',
    this.parents = const [],
    this.children = const [],
    Tags? tags,
    this.notes = '',
    this.customFields = const {},
    this.uploadedFiles = const [],
    DateTime? dateOfMate,
    DateTime? dateOfDeadOrSell,
    DateTime? dateOfWeaning,
    this.breedingStage = '',
  })  : dob = dob ?? DateTime.now(),
        dateOfMate = dateOfMate ?? DateTime.now(),
        dateOfDeadOrSell = dateOfDeadOrSell ?? DateTime.now(),
        dateOfWeaning = dateOfWeaning ?? DateTime.now(),
        tags = tags ?? Tags();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dob': dob.toIso8601String(),
      'name': name,
      'breed': breed,
      'image': image,
      'sex': sex,
      'parents': parents.map((x) => x.toMap()).toList(),
      'children': children.map((x) => x.toMap()).toList(),
      'tags': tags.toMap(),
      'notes': notes,
      'customFields': customFields,
      'uploadedFiles': uploadedFiles,
      'dateOfMate': dateOfMate.toIso8601String(),
      'dateOfDeadOrSell': dateOfDeadOrSell.toIso8601String(),
      'dateOfWeaning': dateOfWeaning.toIso8601String(),
      'breedingStage': breedingStage,
    };
  }

  factory Sheep.fromMap(Map<String, dynamic> map) {
    return Sheep(
      id: map['id'] as String,
      dob: DateTime.parse(map['dob'] as String),
      name: map['name'] as String,
      breed: map['breed'] as String,
      image: map['image'] as String,
      sex: map['sex'] as String,
      parents: (map['parents'] as List<dynamic>)
          .map<Sheep>((x) => Sheep.fromMap(x as Map<String, dynamic>))
          .toList(),
      children: (map['children'] as List<dynamic>)
          .map<Sheep>((x) => Sheep.fromMap(x as Map<String, dynamic>))
          .toList(),
      tags: Tags.fromMap(map['tags'] as Map<String, dynamic>),
      notes: map['notes'] as String,
      customFields:
          Map<String, String>.from(map['customFields'] as Map<String, dynamic>),
      uploadedFiles: List<String>.from(map['uploadedFiles'] as List<dynamic>),
      dateOfMate: DateTime.parse(map['dateOfMate'] as String),
      dateOfDeadOrSell: DateTime.parse(map['dateOfDeadOrSell'] as String),
      dateOfWeaning: DateTime.parse(map['dateOfWeaning'] as String),
      breedingStage: map['breedingStage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Sheep.fromJson(String source) =>
      Sheep.fromMap(json.decode(source) as Map<String, dynamic>);
}
