// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'farm_animals.dart';

class User {
  String id;
  String email;
  String password;
  String phoneNumber;
  String firstName;
  String lastName;
  String address;
  List<FarmAnimals> farmAnimals;
  List<User> friends;
  String imageUrl;

  User({
    this.id = '',
    this.email = '',
    this.password = '',
    this.phoneNumber = '',
    this.firstName = '',
    this.lastName = '',
    this.address = '',
    this.farmAnimals = const [],
    this.friends = const [],
    this.imageUrl = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'farmAnimals': farmAnimals.map((x) => x.toMap()).toList(),
      'friends': friends.map((x) => x.toMap()).toList(),
      'imageUrl': imageUrl,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      phoneNumber: map['phoneNumber'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      address: map['address'] as String,
      farmAnimals: List<FarmAnimals>.from(
        (map['farmAnimals'] as List<int>).map<FarmAnimals>(
          (x) => FarmAnimals.fromMap(x as Map<String, dynamic>),
        ),
      ),
      friends: List<User>.from(
        (map['friends'] as List<int>).map<User>(
          (x) => User.fromMap(x as Map<String, dynamic>),
        ),
      ),
      imageUrl: map['imageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
