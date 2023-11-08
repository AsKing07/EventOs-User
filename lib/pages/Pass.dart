import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_project/config/size.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../Widgets/clipper.dart';
import '../config/config.dart';
import 'package:social_media_buttons/social_media_buttons.dart';

class Pass extends StatefulWidget {
  final String passCode;
  final bool isOnline;
  final String eventCode;
  const Pass(this.passCode, this.eventCode, this.isOnline, {super.key});

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
                                  "Permet ${passDetails['ticketCount']} personne(s)",
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
