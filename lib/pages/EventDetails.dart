// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project/pages/PassListPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_project/pages/Announcements.dart';
import 'package:flutter_project/config/size.dart';
import 'package:flutter_project/pages/confirmation.dart';
import '../config/config.dart';

import 'package:clipboard/clipboard.dart';

class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;
  final String uid;
  final int currentIndex;

  DetailPage(this.currentIndex, this.post, this.uid);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController eventCodeController = TextEditingController();
  late String writtenCode, passCode;
  int index = 0;

  void showPass() async {
    // Passer à la page PassListPage avec les informations nécessaires
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PassListPage(widget.post['eventCode'], widget.post['isOnline'])),
    );
  }

  void nextPage(BuildContext context, double height) async {
    // final x = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(widget.uid)
    //     .collection('eventJoined')
    //     .doc(widget.post['eventCode'])
    //     .get();

    if (widget.post['joined'] >= widget.post['maxAttendee']) {
      Fluttertoast.showToast(
          msg: "Plus de billets disponibles",
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
    //Venir commenter plus tard si un utilisateur peut acheter plusieurs billets, mais s'assurer qu'il pourra voir les deux pass
    //Pour le moment un pass par utilisateur
    //Un pass peut donner droit à plusieurs entrées
    // else if (x.exists) {
    //   Fluttertoast.showToast(
    //       msg: "Vous avez déjà rejoint cet événement",
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white);
    //
    // }
    else if (widget.post['isProtected']) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            scrollable: true,
            backgroundColor: AppColors.secondary,
            title: const Center(
              child: Text(
                "Obtenir le Pass d'Entrée",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                ),
              ),
            ),
            content: SizedBox(
              height: height / 5,
              child: Column(
                children: [
                  TextField(
                    controller: eventCodeController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                    cursorColor: AppColors.primary,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: "Entrez le code de l'événement",
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.post['eventCode'] ==
                              eventCodeController.text) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BuyTicket(widget.post),
                              ),
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: "Code incorrect saisi",
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Obtenir le Pass",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ).then((value) {
        eventCodeController.clear();
      });
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => BuyTicket(widget.post)));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.getWidth(context);
    double height = SizeConfig.getHeight(context);
    final eventData = widget.post;

    return Scaffold(
        bottomNavigationBar: widget.currentIndex == 0
            ? null
            : BottomNavigationBar(
                backgroundColor: AppColors.primary,
                currentIndex: index,
                selectedItemColor: AppColors.secondary,
                unselectedItemColor: Colors.white,
                onTap: (val) {
                  setState(() {
                    index = val;
                  });
                },
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.info), label: 'Détails'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.announcement), label: 'Annonces')
                ],
              ),
        body: index == 0
            ? ListView(
                children: [
                  Container(
                    transform: Matrix4.translationValues(0, -25, 0),
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 2,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(eventData['eventBanner']),
                          )),
                        ),
                        Positioned(
                          right: 10,
                          left: 10,
                          top: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.keyboard_backspace,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: const Color(0xffde554d),
                                child: Text(
                                  DateFormat('dd MMM yyy').format(
                                      eventData['eventDateTime'].toDate()),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          left: 10,
                          right: 10,
                          bottom: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                eventData['eventName'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.category,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    eventData['eventCategory'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            !eventData['isOnline']
                                ? Text(
                                    '${eventData['position']}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  )
                                : const Text("")
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 15,
                                ),
                                !eventData['isOnline']
                                    ? Text(
                                        '${eventData['eventAddress']}',
                                        softWrap: true,
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      )
                                    : const Text("En ligne")
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time_outlined,
                                  size: 15,
                                ),
                                Text(
                                  DateFormat('hh:mm').format(
                                      eventData['eventDateTime'].toDate()),
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${eventData['maxAttendee'] - eventData['joined']} tickets restant',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.money_rounded,
                                  size: 15,
                                ),
                                Text(
                                  eventData['isPaid']
                                      ? 'FCFA ${eventData['ticketPrice']}'
                                      : 'Gratuit',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: Material(
                            color: const Color(0xffde554d),
                            child: MaterialButton(
                              child: Text(
                                DateTime.now().isAfter(
                                        eventData['eventDateTime'].toDate())
                                    ? 'Evènement Passé'
                                    : 'Acheter un Pass',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () {
                                if (DateTime.now().isAfter(
                                    eventData['eventDateTime'].toDate())) {
                                  Fluttertoast.showToast(
                                      msg: "Cet évènement est déjà passé");
                                } else {
                                  nextPage(context, height);
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: Material(
                            color: const Color(0xffde554d),
                            child: MaterialButton(
                              child: const Text(
                                'Afficher mes Pass',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () {
                                showPass();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          eventData['eventDescription'],
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Organisateur',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.info,
                                  size: 15,
                                ),
                                Text(
                                  ' ${eventData['hostName']}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              '${eventData['hostEmail']}',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${eventData['hostPhoneNumber']}',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[700]),
                            ),
                            IconButton(
                                icon: const Icon(Icons.content_copy),
                                onPressed: () {
                                  FlutterClipboard.copy(
                                          '${eventData['hostPhoneNumber']}')
                                      .then((value) => Fluttertoast.showToast(
                                          msg: 'Copié dans le presse-papiers'));
                                })
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: Material(
                            color: const Color(0xffde554d),
                            child: MaterialButton(
                              child: const Text(
                                "Voir les annonces de l'évènement",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Announcements(
                                            eventData['eventCode'],
                                            eventData['isOnline'])));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Announcements(eventData['eventCode'], eventData['isOnline']));
  }
}
