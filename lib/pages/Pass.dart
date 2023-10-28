import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_project/config/size.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../Widgets/clipper.dart';
import '../config/config.dart';
import 'package:social_media_buttons/social_media_buttons.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Pass extends StatefulWidget {
  final String passCode;
  final bool isOnline;
  final String eventCode;
  const Pass(this.passCode, this.eventCode, this.isOnline, {super.key});

  void sendMail() async {
    late String? userToken;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    if (user != null) {
      userToken = await user.getIdToken();
      print('Token de l\'utilisateur : $userToken');
    } else {
      print('L\'utilisateur n\'est pas connecté.');
    }

    final email = user?.email;
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/qr_code.png');
    ByteData? qrBytes = await QrPainter(
      data: passCode,
      gapless: true,
      version: QrVersions.auto,
      color: Color.fromRGBO(0, 118, 191, 1),
      emptyColor: Colors.white,
    ).toImageData(878);

    final buffer = qrBytes!.buffer.asUint8List();
    await file.writeAsBytes(buffer);

    if (email != null) {
      final server = gmail('charbelsnn@gmail.com', 'cybnxrgfsydiyrtw');

      final message = Message()
        ..from = Address('charbelsnn@gmail.com', 'L\'Equipe EventOs')
        ..recipients.add(email)
        ..subject = 'Votre Pass'
        ..html =
            ' <p>Veuillez trouver ci-joint votre QR Code pour accéder à l\'événement. Votre QR Code reste cependant disponible via l\'application </p> <p>Ce code QR Code sera scanné à votre présentation à l\'évènement </p> <p>Une fois scanné, il n\'est plus utilisable. Veuillez donc bien le conservé </p> <img src="cid:qr_code_image"> '
        ..attachments.add(
          FileAttachment(File(file.path))
            ..location = Location.inline
            ..cid = '<qr_code_image>',
        );

      try {
        final sendReport = await send(message, server);
        print('Message envoyé: ' + sendReport.toString());
        if (userToken != null) {
          sendNotificationToUser(userToken);
        }
      } on MailerException catch (e) {
        print('Message non envoyé.');
        for (var p in e.problems) {
          print('Problemes: ${p.code}: ${p.msg}');
        }
      }
    }
  }

  void sendNotificationToUser(String userToken) async {
    const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

    final Map<String, dynamic> notification = {
      'to': userToken, // Token FCM de l'utilisateur
      'notification': {
        'title': 'Nouveau message',
        'body': 'Vous avez reçu un nouvel e-mail',
      },
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAxVId5K8:APA91bERzf3CpSnGNBDYhCZghvy2-q7LHMEBA33xime_t9rr8fikxGqsRCZwaRjb1uTVepo3vaWXy6kMnJGpAgHTvlOyYL5-kn7AlbpK5AVzdC9IszjA9QgPeXt7XyziUQWogiX3_Fx1',
    };

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: headers,
      body: jsonEncode(notification),
    );

    if (response.statusCode == 200) {
      print('Notification envoyée avec succès.');
    } else {
      print('Échec de l\'envoi de la notification : ${response.reasonPhrase}');
    }
  }

  @override
  _PassState createState() => _PassState();
}

class _PassState extends State<Pass> {
  late DocumentSnapshot passDetails;

  void getPassDetails() async {
    if (widget.isOnline) {
      passDetails = await FirebaseFirestore.instance
          .collection('OnlineEvents')
          .doc(widget.eventCode)
          .collection('guests')
          .doc(widget.passCode)
          .get();
      setState(() {});
    } else {
      passDetails = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventCode)
          .collection('guests')
          .doc(widget.passCode)
          .get();
      setState(() {});
    }
  }

  Future getDetails() async {
    if (widget.isOnline) {
      final x = await FirebaseFirestore.instance
          .collection('OnlineEvents')
          .doc(widget.eventCode)
          .get();
      return x;
    } else {
      final x = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventCode)
          .get();
      return x;
    }
  }

  @override
  void initState() {
    super.initState();
    getPassDetails();
  }

  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.getHeight(context);
    double width = SizeConfig.getWidth(context);
    return Scaffold(
      backgroundColor: AppColors.tertiary,
      body: FutureBuilder(
          future: getDetails(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting ||
                !snap.hasData) {
              return Center(
                  child:
                      SpinKitChasingDots(color: AppColors.secondary, size: 60));
            } else {
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipPath(
                      clipper: BottomWaveClipper(),
                      child: Container(
                        color: AppColors.secondary,
                        height: 150,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: width / 15, vertical: height / 15),
                          width: width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(
                                  text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: "Event",
                                    style: GoogleFonts.lora(
                                        textStyle: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold))),
                                TextSpan(
                                    text: "Os",
                                    style: GoogleFonts.lora(
                                        textStyle: TextStyle(
                                            color: Colors.pink[600],
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold))),
                              ])),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Image.asset(
                                  'assets/logo.png',
                                  height: 80,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: width / 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: width / 1.8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(height: 5),
                                      Text(
                                        "${snap.data['eventName']}",
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w700),
                                        textAlign: TextAlign.left,
                                      ),
                                      const SizedBox(height: 20),
                                      const Text(
                                        "DATE & HEURE",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        DateFormat('dd-MM-yyyy, hh:mm a')
                                            .format(snap.data['eventDateTime']
                                                .toDate()),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "CODE DU PASS",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        widget.passCode,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "ADDRESSE",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        "${snap.data['isOnline'] ? 'Evenement en ligne' : snap.data['eventAddress']}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Image.network(
                                  snap.data['eventBanner'],
                                  height: height / 5,
                                  alignment: Alignment.centerRight,
                                ))
                              ]),
                        ),
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: QrImageView(
                                data: widget.passCode,
                                version: QrVersions.auto,
                                size: 200.0,
                              ),
                            ),
                          ),
                        ),
                        // ignore: unnecessary_null_comparison
                        passDetails != null
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Permet ${passDetails['ticketCount']} entrée(s)",
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                SocialMediaButton.facebook(
                                  url: 'https://www.facebook.com/',
                                  size: 35,
                                  color: AppColors.primary,
                                ),
                                SocialMediaButton.instagram(
                                  url: 'https://www.instagram.com/',
                                  size: 35,
                                  color: AppColors.primary,
                                ),
                                SocialMediaButton.twitter(
                                  url: '',
                                  size: 35,
                                  color: AppColors.primary,
                                ),
                              ]),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
