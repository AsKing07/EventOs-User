import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAdd {
  addUser(
      String name, String email, String phoneNumber, String uid, bool isBenin) {
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'uid': uid,
      'isBenin': isBenin
    });
  }
}
