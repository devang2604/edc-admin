import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vp_admin/models/notification_model.dart';
import 'package:vp_admin/models/ticket_data.dart';
import 'package:vp_admin/models/user_data.dart';

class DatabaseService {
  // collection reference
  final CollectionReference adminCollection =
      FirebaseFirestore.instance.collection('admins');

  static final CollectionReference admittedUserCollection =
      FirebaseFirestore.instance.collection('admitted_users');

  static final CollectionReference registeredUserCollection =
      FirebaseFirestore.instance.collection('vp23_registration');

  Future<bool> isAdmin(String email) async {
    try {
      final snapshot =
          await adminCollection.where('email', isEqualTo: email).get();
      print(snapshot.docs);
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<String> uploadImage(File file) {
    final ref = FirebaseStorage.instance.ref().child('images/${file.path}');
    final uploadTask = ref.putFile(file);
    return uploadTask.then((res) => res.ref.getDownloadURL());
  }

  static Future addNotification(NotMessage notification) async {
    try {
      notification.createdAt = Timestamp.now();
      final ref = FirebaseFirestore.instance.collection('notifications');
      await ref.add(notification.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Query<NotMessage> getNotifications() {
    return FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .withConverter<NotMessage>(
          fromFirestore: (snapshot, _) => NotMessage.fromMap(snapshot.data()!),
          toFirestore: (message, _) => message.toMap(),
        );
  }

  static Future addUser(UserData userData) async {
    return await admittedUserCollection.add(userData.toMap());
  }

  static Future addTicketToAdmittedUser(TicketData ticketData) async {
    UserData userData = UserData(
      id: ticketData.ticketId,
      firstName: ticketData.name,
      email: ticketData.email,
      phone: ticketData.phone,
      type: ticketData.ticketType,
      createdAt: ticketData.createdAt,
    );
    return await admittedUserCollection.doc(userData.id).set(userData.toMap());
  }

  Future<void> updateFlag(uid, bool flag) async {
    await admittedUserCollection.doc(uid).update(
      {
        'flag': flag,
      },
    );
  }

  Future<TicketData?> verifyTicketId(String? code) async {
    try {
      if (code == null) return null;
      final snapshot = await registeredUserCollection.doc(code).get();
      if (snapshot.exists) {
        return TicketData.fromMap(
            snapshot.data() as Map<String, dynamic>, code);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getTicketData(String id) async {
    print("id: $id");
    try {
      final snapshot = await registeredUserCollection.doc(id).get();
      return TicketData.fromMap(snapshot.data() as Map<String, dynamic>, id);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future searchByEmail(String id) async {
    try {
      final snapshot =
          await registeredUserCollection.where('email', isEqualTo: id).get();
      return TicketData.fromMap(
          snapshot.docs.first.data() as Map<String, dynamic>, id);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<String?> addTicket(TicketData ticketData) async {
    try {
      //Get latest ticket id and increment it by 1
      final snapshot =
          await registeredUserCollection.orderBy('created_at').get();
      final lastTicket = snapshot.docs.last;
      final lastTicketId = lastTicket.id;
      final newTicketId = int.parse(lastTicketId) + 1;
      ticketData.ticketId = newTicketId.toString();
      ticketData.createdAt = Timestamp.now();
      return registeredUserCollection
          .doc(ticketData.ticketId)
          .set(
            ticketData.toMap(),
          )
          .then((value) => ticketData.ticketId);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  Future<bool> isUserAdmitted(String ticketId) async {
    try {
      final snapshot = await admittedUserCollection.doc(ticketId).get();
      return snapshot.exists;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
