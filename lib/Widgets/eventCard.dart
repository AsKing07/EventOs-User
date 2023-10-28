import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_project/pages/EventDetails.dart';
import 'package:flutter_project/config/config.dart';
import 'package:flutter_project/Methods/getUserId.dart';

Widget eventCard(DocumentSnapshot event, double height, double width, int page,
    BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.02),
      height: height * 0.3,
      child: Card(
        color: Colors.deepPurple[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Image.network(
                          event['eventBanner'],
                          fit: BoxFit.fitHeight,
                          width: width * 0.3,
                          height: height * 0.3,
                        )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 16, 8, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "${event['eventName']}",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: AppColors.primary)),
                                  textAlign: TextAlign.start,
                                )),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      DateFormat('hh:mm a').format(
                                          event['eventDateTime'].toDate()),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      DateFormat('EEE, d MMMM yyyy').format(
                                          event['eventDateTime'].toDate()),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          String uid = await getCurrentUid();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return DetailPage(
                                                    page, event, uid);
                                              },
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: AppColors.primary,
                                          backgroundColor: AppColors
                                              .tertiary, // Couleur du texte
                                          elevation: 2, // Élévation du bouton
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10.0), // Bordure du bouton
                                          ),
                                        ),
                                        child: const Text(
                                          "Détails de l'événement",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: width,
                    color: AppColors.secondary,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 5),
                      child: Text(
                          event['isOnline']
                              ? 'Evènement en ligne'
                              : "${event['eventAddress']}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ),
                  ))
            ]),
      ),
    ),
  );
}
