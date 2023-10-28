import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/Methods/getUserId.dart';
// import 'package:flutter_project/Models/user.dart';
import 'package:flutter_project/services/notification.dart';
import 'package:random_string/random_string.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

class GetPass {
  Future<String> bookPass(
      DocumentSnapshot post, int ticketCount, String transactionId) async {
    final Event event = Event(
      title: post['eventName'],
      description: post['eventDescription'],
      location: 'Event location',
      startDate: post['eventDateTime'].toDate(),
      endDate: post['eventDateTime'].toDate().add(Duration(hours: 3)),
      allDay: true,
    );

    String uid = await getCurrentUid();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = await auth.currentUser;

    // final userDoc =
    //     await FirebaseFirestore.instance.collection('users').doc(uid).get();
    // User user = User.fromDocument(userDoc);
    await Add2Calendar.addEvent2Cal(event);

    if (!post['isPaid']) {
      String passCode = randomAlphaNumeric(8);
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('eventJoined')
          .doc(post['eventCode'])
          .set({
        'eventCode': post['eventCode'],
        'passCode': passCode,
        'pay_id': null,
        'ticketCount': 1,
        'dateTime': DateTime.now(),
      });
      fcm.subscribeToTopic(post['eventCode']);

      if (!post['isOnline']) {
        FirebaseFirestore.instance
            .collection("events")
            .doc(post['eventCode'])
            .collection('guests')
            .doc(passCode)
            .set({
          'user': user!.uid,
          'phone': user.phoneNumber,
          'email': user.email,
          'name': user.displayName,
          'passCode': passCode,
          'Scanned': false,
          'pay_id': null,
          'ticketCount': 1,
        });
        FirebaseFirestore.instance
            .collection('events')
            .doc(post['eventCode'])
            .update({
          'joined': FieldValue.increment(1),
        });
      } else {
        FirebaseFirestore.instance
            .collection("OnlineEvents")
            .doc(post['eventCode'])
            .collection('guests')
            .doc(passCode)
            .set({
          'user': user!.uid,
          'phone': user.phoneNumber,
          'email': user.email,
          'name': user.displayName,
          'passCode': passCode,
          'Scanned': false,
          'pay_id': null,
          'ticketCount': 1,
        });
        FirebaseFirestore.instance
            .collection('OnlineEvents')
            .doc(post['eventCode'])
            .update({
          'joined': FieldValue.increment(1),
        });
      }

      return passCode;
    } else if (post['isPaid'] && post['partner'] != null) {
      String passCode = randomAlphaNumeric(8);
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('eventJoined')
          .doc(post['eventCode'])
          .set({
        'eventCode': post['eventCode'],
        'passCode': passCode,
        'pay_id': transactionId,
        'ticketCount': ticketCount,
        'dateTime': DateTime.now(),
      });
      FirebaseFirestore.instance.collection('payments').doc(transactionId).set({
        'eventCode': post['eventCode'],
        'passCode': passCode,
        'pay_id': transactionId,
        'amount': post['ticketPrice'] * ticketCount,
        'user': user!.uid,
        'phone': user.phoneNumber,
        'email': user.email,
        'name': user.displayName,
      });
      fcm.subscribeToTopic(post['eventCode']);

      FirebaseFirestore.instance
          .collection('partners')
          .doc(post['partner'])
          .update({
        'amount_to_be_paid_total':
            FieldValue.increment(post['ticketPrice'] * ticketCount * 2 / 100),
        'amount_total':
            FieldValue.increment(post['ticketPrice'] * ticketCount * 2 / 100),
      });

      FirebaseFirestore.instance
          .collection('partners')
          .doc(post['partner'])
          .collection('eventsPartnered')
          .doc(post['eventCode'])
          .update({
        'amount_to_be_paid':
            FieldValue.increment(post['ticketPrice'] * ticketCount * 2 / 100),
        'amount_earned':
            FieldValue.increment(post['ticketPrice'] * ticketCount * 2 / 100),
      });

      if (!post['isOnline']) {
        FirebaseFirestore.instance
            .collection("events")
            .doc(post['eventCode'])
            .collection('guests')
            .doc(passCode)
            .set({
          'user': user.uid,
          'phone': user.phoneNumber,
          'email': user.email,
          'name': user.displayName,
          'passCode': passCode,
          'Scanned': false,
          'pay_id': transactionId,
          'ticketCount': ticketCount,
          'ticketPrice': post['ticketPrice'],
        });
        FirebaseFirestore.instance
            .collection('events')
            .doc(post['eventCode'])
            .update({
          'joined': FieldValue.increment(ticketCount),
          'amountEarned':
              FieldValue.increment(post['ticketPrice'] * ticketCount),
          'amount_to_be_paid':
              FieldValue.increment(post['ticketPrice'] * ticketCount),
        });
      } else {
        FirebaseFirestore.instance
            .collection("OnlineEvents")
            .doc(post['eventCode'])
            .collection('guests')
            .doc(passCode)
            .set({
          'user': user.uid,
          'phone': user.phoneNumber,
          'email': user.email,
          'name': user.displayName,
          'passCode': passCode,
          'Scanned': false,
          'pay_id': transactionId,
          'ticketCount': ticketCount,
          'ticketPrice': post['ticketPrice'],
        });
        FirebaseFirestore.instance
            .collection('OnlineEvents')
            .doc(post['eventCode'])
            .update({
          'joined': FieldValue.increment(ticketCount),
          'amountEarned':
              FieldValue.increment(post['ticketPrice'] * ticketCount),
          'amount_to_be_paid':
              FieldValue.increment(post['ticketPrice'] * ticketCount),
        });
      }

      return passCode;
    } else if (post['isPaid'] && post['partner'] == null) {
      String passCode = randomAlphaNumeric(8);
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('eventJoined')
          .doc(post['eventCode'])
          .set({
        'eventCode': post['eventCode'],
        'passCode': passCode,
        'pay_id': transactionId,
        'ticketCount': ticketCount,
        'dateTime': DateTime.now(),
        'ticketPrice': post['ticketPrice'],
      });
      FirebaseFirestore.instance.collection('payments').doc(transactionId).set({
        'eventCode': post['eventCode'],
        'passCode': passCode,
        'pay_id': transactionId,
        'amount': post['ticketPrice'] * ticketCount,
        'user': user!.uid,
        'phone': user.phoneNumber,
        'email': user.email,
        'name': user.displayName,
      });
      fcm.subscribeToTopic(post['eventCode']);

      if (!post['isOnline']) {
        FirebaseFirestore.instance
            .collection("events")
            .doc(post['eventCode'])
            .collection('guests')
            .doc(passCode)
            .set({
          'user': user.uid,
          'phone': user.phoneNumber,
          'email': user.email,
          'name': user.displayName,
          'passCode': passCode,
          'Scanned': false,
          'pay_id': transactionId,
          'ticketCount': ticketCount,
          'ticketPrice': post['ticketPrice'],
        });
        FirebaseFirestore.instance
            .collection('events')
            .doc(post['eventCode'])
            .update({
          'joined': FieldValue.increment(ticketCount),
          'amountEarned':
              FieldValue.increment(post['ticketPrice'] * ticketCount),
          'amount_to_be_paid':
              FieldValue.increment(post['ticketPrice'] * ticketCount),
        });
      } else {
        FirebaseFirestore.instance
            .collection("OnlineEvents")
            .doc(post['eventCode'])
            .collection('guests')
            .doc(passCode)
            .set({
          'user': user.uid,
          'phone': user.phoneNumber,
          'email': user.email,
          'name': user.displayName,
          'passCode': passCode,
          'Scanned': false,
          'pay_id': transactionId,
          'ticketCount': ticketCount,
          'ticketPrice': post['ticketPrice'],
        });
        FirebaseFirestore.instance
            .collection('OnlineEvents')
            .doc(post['eventCode'])
            .update({
          'joined': FieldValue.increment(ticketCount),
          'amountEarned':
              FieldValue.increment(post['ticketPrice'] * ticketCount),
          'amount_to_be_paid':
              FieldValue.increment(post['ticketPrice'] * ticketCount),
        });
      }

      return passCode;
    }

    return '';
  }
}
