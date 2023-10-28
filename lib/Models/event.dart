import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  Timestamp timestamp;
  String media;
  String description;
  String? id;

  Event(
      {required this.description,
      required this.media,
      required this.timestamp,
      this.id});

  factory Event.fromDocument(DocumentSnapshot doc) {
    return Event(
        description: doc['description'],
        timestamp: doc['timestamp'],
        media: doc['media'],
        id: doc['id']);
  }
}
