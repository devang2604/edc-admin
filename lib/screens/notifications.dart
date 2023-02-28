import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vp_admin/constants.dart';
import 'package:vp_admin/screens/notification_history.dart';
import 'package:vp_admin/services/database.dart';
import 'package:vp_admin/widgets/text_fields.dart';
import 'package:image_picker/image_picker.dart';
import '../models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = false;
  bool isUploading = false;

  final List<String> topics = [
    'all',
    'admitted',
    'notAdmitted',
  ];

  NotMessage notificationData = NotMessage();

  final _formKey = GlobalKey<FormState>();

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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: kPadding,
          children: [
            //Topic
            const Text(
              'Send a notification',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            //Select topic
            DropdownButtonFormField<String>(
              value: notificationData.topic,
              items: topics.map((topic) {
                return DropdownMenuItem(
                  value: topic,
                  child: Text(topic.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {},
              decoration: const InputDecoration(
                labelText: 'Topic',
                border: OutlineInputBorder(),
              ),
            ),
            //Title
            InputTextField(
              initialValue: notificationData.title,
              label: 'Title',
              hint: 'New update',
              onChanged: (value) {
                setState(() {
                  notificationData.title = value;
                });
              },
            ),
            //Body
            InputTextField(
              initialValue: notificationData.body,
              maxLines: 3,
              label: 'Body',
              hint: 'New update is available',
              onChanged: (value) {
                setState(() {
                  notificationData.body = value;
                });
              },
            ),
            const SizedBox(height: 8),
            //Image
            isUploading
                ? Center(
                    child: Column(
                    children: const [
                      LinearProgressIndicator(),
                      SizedBox(height: 8),
                      Text('Uploading image...'),
                    ],
                  ))
                : _buildImageSelector(),
            const SizedBox(height: 8),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && !isUploading) {
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
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                //Send notification
                                await DatabaseService.addNotification(
                                    notificationData);
                                setState(() {
                                  isLoading = false;
                                  notificationData = NotMessage();
                                });
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Notification sent'),
                                  ),
                                );
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
                  }
                },
                style: kElevatedButtonStyle,
                child: const Text('Send'))
          ],
        ),
      ),
    );
  }

  _buildImageSelector() {
    return notificationData.imageUrl == null
        ? Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      // style: TextButton.styleFrom(
                      //   // foregroundColor: Colors.white,
                      //   backgroundColor: Colors.transparent.withOpacity(0.9),
                      // ),
                      onPressed: _imagePicker,
                      child: const Text('Select image'),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'No image selected',
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Note: Image is optional',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          )
        :
        //Show image preview, remove and edit button
        Stack(children: [
            Image.network(notificationData.imageUrl!,
                height: 200, width: double.infinity, fit: BoxFit.cover),
            Positioned(
              top: 0,
              right: 0,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    notificationData.imageUrl = null;
                  });
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ]);
  }

  void _imagePicker() async {
    //Pick image from gallery
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    //If image is picked upload it to firebase storage
    if (pickedImage != null) {
      setState(() {
        isUploading = true;
      });
      final imageUrl =
          await DatabaseService.uploadImage(File(pickedImage.path));
      setState(() {
        notificationData.imageUrl = imageUrl;
        isUploading = false;
      });
    }
  }
}
