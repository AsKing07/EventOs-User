import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAdd {
  addUser(String? name, String? email, String? phoneNumber, String? uid,
      bool? isBenin) {
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'uid': uid,
      'isBenin': isBenin
    }, SetOptions(merge: true));
  }
}
