import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:geoflutterfire2/geoflutterfire2.dart';

class Club {
  String name;
  String poster;
  String description;
  String timings;
  List<String> photos; //not more than 3
  String type; //club or restaurant
  String contact; //email or phone
  String address;
  int avgPrice;
  double stars; //out of 5
  GeoFlutterFire position; //geolocation

  Club(
      {required this.description,
      required this.name,
      required this.photos,
      required this.poster,
      required this.contact,
      required this.timings,
      required this.type,
      required this.position,
      required this.stars,
      required this.avgPrice,
      required this.address});

  factory Club.fromDocument(DocumentSnapshot doc) {
    return Club(
        description: doc['description'],
        name: doc['name'],
        poster: doc['poster'],
        timings: doc['timings'],
        photos: doc['photos'],
        type: doc['type'],
        contact: doc['contact'],
        avgPrice: doc['avgPrice'],
        stars: doc['stars'],
        position: doc['position'],
        address: doc['address']);
  }
}
