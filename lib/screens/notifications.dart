import 'package:flutter/material.dart';
import 'package:vp_admin/constants.dart';
import 'package:vp_admin/screens/notification_history.dart';
import 'package:vp_admin/services/database.dart';
import 'package:vp_admin/widgets/text_fields.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String title = '';
  String body = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          //See history of notifications
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NotificationHistoryPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: kPadding,
        children: [
          //Title
          InputTextField(
            label: 'Title',
            hint: 'New update',
            onChanged: (value) {
              setState(() {
                title = value;
              });
            },
          ),
          //Body
          InputTextField(
            maxLines: 3,
            label: 'Body',
            hint: 'New update is available',
            onChanged: (value) {
              setState(() {
                body = value;
              });
            },
          ),
          const SizedBox(height: 8),
          ElevatedButton(
              onPressed: () {
                //Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Confirm'),
                      content: const Text(
                          'Are you sure you want to send this notification? This action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // DatabaseService.addNotification(
                            //   title: _titleController.text,
                            //   body: _bodyController.text,
                            //   image: '',
                            // ).then((value) {
                            //   //Show toast
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(
                            //       content: Text('Notification sent!'),
                            //       backgroundColor: Colors.green,
                            //     ),
                            //   );
                            //   //Clear text fields
                            //   _titleController.clear();
                            //   _bodyController.clear();
                            //   //Close dialog
                            //   Navigator.of(context).pop();
                            // });
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: kElevatedButtonStyle,
              child: const Text('Send'))
        ],
      ),
    );
  }
}
