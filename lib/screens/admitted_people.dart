import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vp_admin/models/user_data.dart';
import 'package:vp_admin/services/database.dart';

class AdmittedPeopleScreen extends StatefulWidget {
  const AdmittedPeopleScreen({super.key});

  @override
  State<AdmittedPeopleScreen> createState() => _AdmittedPeopleScreenState();
}

class _AdmittedPeopleScreenState extends State<AdmittedPeopleScreen> {
  late Query<UserData> _query;

  @override
  void initState() {
    super.initState();
    _query = FirebaseFirestore.instance
        .collection('admitted_users')
        .orderBy('createdAt', descending: true)
        .withConverter<UserData>(
          fromFirestore: (snapshot, _) =>
              UserData.fromMap(snapshot.data()!, snapshot.id),
          toFirestore: (userData, _) => userData.toMap(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Admitted People")),
        body: FirestoreListView<UserData>(
          query: _query,
          itemBuilder: (context, userData) {
            final UserData user = userData.data();
            return AdmittedUserCard(user: user);
          },
        ));
  }
}

class AdmittedUserCard extends StatefulWidget {
  const AdmittedUserCard({
    super.key,
    required this.user,
  });

  final UserData user;

  @override
  State<AdmittedUserCard> createState() => _AdmittedUserCardState();
}

class _AdmittedUserCardState extends State<AdmittedUserCard> {
  bool flag = false;

  @override
  void initState() {
    super.initState();
    flag = widget.user.flag;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //
      },
      onLongPress: () {
        setState(() {
          flag = !flag;
        });
        //Update the flag in the database
        DatabaseService().updateFlag(widget.user.id, flag);
      },
      child: Card(
        child: ListTile(
            title: Text("${widget.user.firstName} ${widget.user.lastName}"),
            subtitle: Text(widget.user.email),
            trailing: flag
                ? const Icon(Icons.check_circle, color: Colors.green)
                : null),
      ),
    );
  }
}
