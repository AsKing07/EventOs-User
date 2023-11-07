import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_project/config/config.dart";
import "package:flutter_project/pages/Pass.dart";
import "package:getwidget/getwidget.dart";
import "package:google_fonts/google_fonts.dart";
import "package:lottie/lottie.dart";

class PassListPage extends StatefulWidget {
  final String eventCode;
  final bool isOnline;

  PassListPage(this.eventCode, this.isOnline);

  @override
  _PassListPageState createState() => _PassListPageState();
}

class _PassListPageState extends State<PassListPage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  late DocumentSnapshot x;

  void getDetails() async {
    if (widget.isOnline) {
      x = await FirebaseFirestore.instance
          .collection('OnlineEvents')
          .doc(widget.eventCode)
          .get();
      setState(() {});
    } else {
      x = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventCode)
          .get();
      setState(() {});
    }
  }

  Future<List<DocumentSnapshot>> getPassList() async {
    if (widget.isOnline) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('eventJoined')
          .doc(widget.eventCode)
          .collection("pass")
          .get();
      return querySnapshot.docs;
    } else {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('eventJoined')
          .doc(widget.eventCode)
          .collection("pass")
          .get();
      return querySnapshot.docs;
    }
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pass de l\'évènement'),
      ),
      body: FutureBuilder(
        future: getPassList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty || snapshot.data == null) {
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
                    'Pas encore de Pass pour cet évènement🥲!',
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
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Une erreur s\'est produite.'),
            );
          } else {
            List<DocumentSnapshot> passList =
                snapshot.data as List<DocumentSnapshot>;
            return ListView.builder(
              itemCount: passList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot pass = passList[index];
                return GFListTile(
                  titleText: "Pass ${pass['passCode']}",
                  subTitleText:
                      'Evènement ${x['eventName']}: ${pass['ticketCount']} entrée(s)',
                  icon: const Icon(Icons.remove_red_eye_outlined),
                  onTap: () {
                    // Passer à la page Pass avec les informations du pass sélectionné
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Pass(
                          pass['passCode'],
                          widget.eventCode,
                          widget.isOnline,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
