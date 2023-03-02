import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String type;
  bool flag;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  UserData({
    this.id = "",
    this.firstName = "",
    this.lastName = "",
    this.email = "",
    this.phone = "",
    this.type = "",
    this.flag = false,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'type': type,
      'flag': flag,
      'createdAt': createdAt ?? Timestamp.now(),
      'updatedAt': updatedAt ?? Timestamp.now(),
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map, String id) {
    return UserData(
      id: id,
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      type: map['type'],
      flag: map.containsKey('flag') ? map['flag'] : false,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String get name => "$firstName $lastName";
}
