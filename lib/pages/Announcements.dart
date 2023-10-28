import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../Models/AnnouncementClass.dart';
import '../config/config.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeleton_text/skeleton_text.dart';

class Announcements extends StatefulWidget {
  final String eventCode;
  final bool isOnline;
  Announcements(this.eventCode, this.isOnline);
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Annonces'), // Titre de la page
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(widget.isOnline ? "OnlineEvents" : "events")
            .doc(widget.eventCode)
            .collection("Announcements")
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data!.docs.length == 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      "assets/NoOne.json",
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Pas d\'annonce!',
                      style: GoogleFonts.novaRound(
                        textStyle: TextStyle(
                          color: AppColors.secondary, // Couleur du texte
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                margin: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return announceWidget(
                        Announce.fromDocument(snapshot.data!.docs[index]),
                        widget.eventCode);
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}

Widget announceWidget(Announce announce, String eventCode) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                timeago.format(announce.timestamp!.toDate(), locale: 'fr'),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.red, // Couleur du texte de la date
                ),
              ),
            ],
          ),
        ),
      ),
      if (announce.media != null)
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: announce.media!,
              fit: BoxFit.cover,
              placeholder: (context, url) => SkeletonAnimation(
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: const BoxDecoration(
                    color: Colors
                        .purple, // Couleur de l'arrière-plan de l'image de chargement
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Linkify(
          options: const LinkifyOptions(looseUrl: true),
          onOpen: (link) async {
            if (await canLaunch(link.url)) {
              await launch(link.url);
            } else {
              Fluttertoast.showToast(
                  msg: 'Ne peut pas atteindre le lien $link');
            }
          },
          text: announce.description,
          overflow: TextOverflow.ellipsis,
          maxLines: 30,
          style: GoogleFonts.rubik(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black, // Couleur du texte de la description
          ),
          linkStyle: const TextStyle(color: Colors.blue), // Couleur des liens
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.0),
        child: Divider(
          color: Color(0xFF57419D), // Couleur de la ligne de séparation
          thickness: 1,
        ),
      )
    ],
  );
}
