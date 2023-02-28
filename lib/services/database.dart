import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vp_admin/models/notification_model.dart';
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
    return admittedUserCollection.add(userData.toMap());
  }

  Future<void> updateFlag(uid, bool flag) async {
    await admittedUserCollection.doc(uid).update({'flag': flag});
  }

  Future<bool> verifyTicketId(String? code) async {
    try {
      if (code == null) return false;
      final snapshot = await registeredUserCollection.doc(code).get();
      print("snapshot: ${snapshot.data()}");
      return snapshot.exists;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future getTicketData(String id) async {
    try {
      final snapshot = await registeredUserCollection.doc(id).get();
      return UserData.fromMap(snapshot.data() as Map<String, dynamic>, id);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
