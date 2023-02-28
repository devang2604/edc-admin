import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vp_admin/services/database.dart';
import 'package:vp_admin/widgets/white_card.dart';

import '../models/notification_model.dart';

class NotificationHistoryPage extends StatelessWidget {
  const NotificationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification history'),
      ),
      body: FirestoreListView(
        query: DatabaseService.getNotifications(),
        itemBuilder: (context, snapshot) {
          final notification = snapshot.data();
          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(notification.title),
                  subtitle: Text(notification.body),
                  trailing: Text(
                    notification.topic.toUpperCase(),
                    maxLines: 3,
                  ),
                ),
                if (notification.imageUrl != null)
                  Image.network(
                    notification.imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
