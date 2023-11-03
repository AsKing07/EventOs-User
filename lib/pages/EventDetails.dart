import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_project/pages/Announcements.dart';
import 'package:flutter_project/config/size.dart';
import 'package:flutter_project/pages/confirmation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Pass.dart';
import '../config/config.dart';
import 'package:readmore/readmore.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
    String passCode;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .collection('eventJoined')
        .where('eventCode', isEqualTo: widget.post['eventCode'])
        .get();
    passCode = querySnapshot.docs.elementAt(0)['passCode'];

    // ignore: use_build_context_synchronously
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Pass(passCode, widget.post['eventCode'], widget.post['isOnline']);
    }));
  }

  void nextPage(BuildContext context, double height) async {
    final x = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .collection('eventJoined')
        .doc(widget.post['eventCode'])
        .get();

    if (widget.post['joined'] >= widget.post['maxAttendee']) {
      Fluttertoast.showToast(
          msg: "Plus de billets disponibles",
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
    //Venir commenter plus tard si un utilisateur peut acheter plusieurs billets, mais s'assurer qu'il pourra voir les deux pass
    //Pour le moment un pass par utilisateur
    //Un pass peut donner droit à plusieurs entrées
    else if (x.exists) {
      Fluttertoast.showToast(
          msg: "Vous avez déjà rejoint cet événement",
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (widget.post['isProtected']) {
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

//     return Scaffold(
//       bottomNavigationBar: widget.currentIndex == 0
//           ? null
//           : BottomNavigationBar(
//               backgroundColor: AppColors.primary,
//               currentIndex: index,
//               selectedItemColor: AppColors.secondary,
//               unselectedItemColor: Colors.white,
//               onTap: (val) {
//                 setState(() {
//                   index = val;
//                 });
//               },
//               items: const <BottomNavigationBarItem>[
//                 BottomNavigationBarItem(
//                     icon: Icon(Icons.info), label: 'Détails'),
//                 BottomNavigationBarItem(
//                     icon: Icon(Icons.announcement), label: 'Annonces')
//               ],
//             ),
//       appBar: AppBar(
//         title: Text(
//           index == 0 ? "Détails de l'événement" : 'Annonces',
//         ),
//         centerTitle: true,
//         backgroundColor: AppColors.primary,
//       ),
//       body: index == 0
//           ? SingleChildScrollView(
//               child: Container(
//                 margin: EdgeInsets.symmetric(
//                     horizontal: width / 25, vertical: height * 0.02),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: height / 3.6,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Image.network(
//                             eventData['eventBanner'],
//                             width: width / 2.8,
//                             height: height / 3.6,
//                             fit: BoxFit.fitHeight,
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.fromLTRB(15, 12, 10, 10),
//                               child: Container(
//                                   child: Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   SizedBox(
//                                     height: 50,
//                                     child: Align(
//                                       alignment: Alignment.topLeft,
//                                       child: AutoSizeText(
//                                         "${eventData['eventName']}",
//                                         style: GoogleFonts.varelaRound(
//                                             textStyle: const TextStyle(
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 28)),
//                                         maxLines: 2,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 5),
//                                   Align(
//                                       alignment: Alignment.topLeft,
//                                       child: Text(
//                                         DateFormat('hh:mm a').format(
//                                             eventData['eventDateTime']
//                                                 .toDate()),
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 18),
//                                       )),
//                                   Align(
//                                       alignment: Alignment.topLeft,
//                                       child: Text(
//                                         DateFormat('EEE, d MMMM yyyy').format(
//                                             eventData['eventDateTime']
//                                                 .toDate()),
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.w400,
//                                             fontSize: 14),
//                                       )),
//                                   widget.currentIndex == 0
//                                       ? const SizedBox(height: 10)
//                                       : Container(),
//                                   widget.currentIndex == 0
//                                       ? Align(
//                                           alignment: Alignment.topLeft,
//                                           child: Text(
//                                             eventData['isPaid']
//                                                 ? 'FCFA ${eventData['ticketPrice']}'
//                                                 : 'Gratuit',
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 20),
//                                           ))
//                                       : Container(),
//                                   Expanded(
//                                     child: Align(
//                                       alignment: Alignment.bottomCenter,
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceEvenly,
//                                         children: <Widget>[
//                                           ElevatedButton(
//                                             onPressed: () {
//                                               if (widget.currentIndex == 0) {
//                                                 nextPage(context, height);
//                                               } else {
//                                                 showPass();
//                                               }
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor:
//                                                   AppColors.tertiary,
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(15),
//                                               ),
//                                             ),
//                                             child: Text(
//                                               widget.currentIndex == 0
//                                                   ? 'Obtenir le Pass'
//                                                   : 'Afficher le Pass',
//                                               style: GoogleFonts.alata(
//                                                   fontSize: 20),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               )),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'Catégorie de l\'événement',
//                         style: GoogleFonts.varelaRound(
//                             textStyle: TextStyle(
//                                 color: AppColors.primary,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 24)),
//                       ),
//                     ),
//                     Divider(
//                       color: AppColors.secondary,
//                       height: 10,
//                       thickness: 2,
//                     ),
//                     const SizedBox(height: 15),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         '${eventData['eventCategory']}',
//                         style: TextStyle(fontSize: 20, color: Colors.grey[700]),
//                       ),
//                     ),
//                     !eventData['isOnline']
//                         ? const SizedBox(height: 30)
//                         : Container(),
//                     !eventData['isOnline']
//                         ? Align(
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                               'Adresse',
//                               style: GoogleFonts.varelaRound(
//                                   textStyle: TextStyle(
//                                       color: AppColors.primary,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 24)),
//                             ),
//                           )
//                         : Container(),
//                     !eventData['isOnline']
//                         ? Divider(
//                             color: AppColors.secondary,
//                             height: 10,
//                             thickness: 2,
//                           )
//                         : Container(),
//                     !eventData['isOnline']
//                         ? const SizedBox(height: 15)
//                         : Container(),
//                     !eventData['isOnline']
//                         ? Text(
//                             '${eventData['position']},  ${eventData['eventAddress']}',
//                             style: const TextStyle(fontSize: 18),
//                           )
//                         : Container(),
//                     !eventData['isOnline']
//                         ? const SizedBox(height: 20)
//                         : Container(),
//                     const SizedBox(height: 30),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'Description de l\'événement',
//                         style: GoogleFonts.varelaRound(
//                             textStyle: TextStyle(
//                                 color: AppColors.primary,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 24)),
//                       ),
//                     ),
//                     Divider(
//                       color: AppColors.secondary,
//                       height: 10,
//                       thickness: 2,
//                     ),
//                     const SizedBox(height: 15),
//                     ReadMoreText(
//                       '${eventData['eventDescription']}',
//                       trimLines: 10,
//                       colorClickableText: Colors.pink,
//                       trimMode: TrimMode.Line,
//                       trimCollapsedText: 'Voir plus',
//                       trimExpandedText: 'Voir moins',
//                       moreStyle: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).colorScheme.secondary,
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'Informations sur l\'hôte',
//                         style: GoogleFonts.varelaRound(
//                             textStyle: TextStyle(
//                                 color: AppColors.primary,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 24)),
//                       ),
//                     ),
//                     Divider(
//                       color: AppColors.secondary,
//                       height: 10,
//                       thickness: 2,
//                     ),
//                     const SizedBox(height: 15),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'Nom: ${eventData['hostName']}',
//                         style: TextStyle(fontSize: 20, color: Colors.grey[700]),
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'Email: ${eventData['hostEmail']}',
//                         style: TextStyle(fontSize: 18, color: Colors.grey[700]),
//                       ),
//                     ),
//                     Row(
//                       children: <Widget>[
//                         Text(
//                           'Téléphone: ${eventData['hostPhoneNumber']}',
//                           style:
//                               TextStyle(fontSize: 18, color: Colors.grey[700]),
//                         ),
//                         IconButton(
//                             icon: const Icon(Icons.content_copy),
//                             onPressed: () {
//                               FlutterClipboard.copy(
//                                       '${eventData['hostPhoneNumber']}')
//                                   .then((value) => Fluttertoast.showToast(
//                                       msg: 'Copié dans le presse-papiers'));
//                             })
//                       ],
//                     ),
//                     //Un bouton qui amène sur la page annonce avec les informations de l'évènements
//                     ElevatedButton(
//                         style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all<Color>(
//                                 AppColors.primary)),
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => Announcements(
//                                       eventData['eventCode'],
//                                       eventData['isOnline'])));
//                         },
//                         child: const Padding(
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 10, horizontal: 30),
//                             child: Text('Voir les annonces de cet évènement',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold))))
//                   ],
//                 ),
//               ),
//             )
//           : Announcements(eventData['eventCode'], eventData['isOnline']),
//     );

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
                                    '${eventData['position']}}',
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline,
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
                                widget.currentIndex == 0
                                    ? DateTime.now().isBefore(
                                            eventData['eventDateTime'].toDate())
                                        ? 'Evènement Passé'
                                        : 'Acheter le Pass'
                                    : 'Afficher mon Pass',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () {
                                if (widget.currentIndex == 0) {
                                  nextPage(context, height);
                                } else {
                                  showPass();
                                }
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
