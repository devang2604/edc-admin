import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class NotificationHistoryPage extends StatelessWidget {
  const NotificationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification history'),
      ),
      // body: FirestoreListView(
      //   query: DbService.getNotifications,
      //   itemBuilder: (context, snapshot) {
      //     final data = snapshot.data();
      //     return WhiteCard(
      //       child: ListTile(
      //         title: Text(data['title']),
      //         subtitle: Text(data['body']),
      //         trailing: Text(timeSince(data['timestamp'])),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
