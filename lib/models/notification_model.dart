import 'package:cloud_firestore/cloud_firestore.dart';

class NotMessage {
  String title;
  String body;
  String topic;
  String? imageUrl;
  Timestamp? createdAt;



  NotMessage({
     this.title = '',
     this.body = '',
     this.topic = 'all',
    this.imageUrl,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'topic': topic,
      'imageUrl': imageUrl,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory NotMessage.fromMap(Map<String, dynamic> map) {
    return NotMessage(
      title: map['title'],
      body: map['body'],
      topic: map['topic'],
      imageUrl: map['imageUrl'],
      createdAt: map['createdAt'],
    );
  }
}