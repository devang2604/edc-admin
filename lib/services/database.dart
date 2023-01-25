import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // collection reference
  final CollectionReference adminCollection =
      FirebaseFirestore.instance.collection('admins');

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
}
