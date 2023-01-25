class UserData {
  String firstName;
  String lastName;
  String email;
  String phone;
  String type;

  UserData(
      {this.firstName = "",
      this.lastName = "",
      this.email = "",
      this.phone = "",
      this.type = ""});

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'type': type,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      type: map['type'],
    );
  }
}
