import 'package:cloud_firestore/cloud_firestore.dart';

class TicketData {
  String ticketId;
  String ticketType;
  String email;
  String phone;
  String name;
  Timestamp? createdAt;

  TicketData({
    this.ticketId = "",
    this.ticketType = "",
    this.email = "",
    this.phone = "",
    this.name = "",
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'ticketId': ticketId,
      'ticketType': ticketType,
      'email': email,
      'phone': phone,
      'name': name,
      'created_at':
          (createdAt ?? Timestamp.now()).toDate().millisecondsSinceEpoch
    };
  }

  factory TicketData.fromMap(Map<String, dynamic> map, String ticketId) {
    return TicketData(
        ticketId: ticketId,
        ticketType: map['ticketType'],
        email: map['email'],
        phone: map['phone'].toString(),
        name: map['name'],
        createdAt: Timestamp.fromMillisecondsSinceEpoch(map['created_at']));
  }
}
