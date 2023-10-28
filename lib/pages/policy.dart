import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/config/config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class Policy extends StatelessWidget {
  Policy();
  // final int index;
  // Policy({required this.index});
  // Future getPolicyText() async {
  //   String policyType = index == 0
  //       ? 'privacy'
  //       : index == 1
  //           ? 'TandC'
  //           : 'cancellation';
  //   final policyDoc = await FirebaseFirestore.instance
  //       .collection('policies')
  //       .doc(policyType)
  //       .get();

  //   return policyDoc['text'];
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(index == 0
  //           ? 'Politique de confidentialité'
  //           : index == 1
  //               ? 'Conditions générales'
  //               : 'Politique d\'annulation'),
  //     ),
  //     body: SingleChildScrollView(
  //       child: FutureBuilder(
  //         future: getPolicyText(),
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return Center(
  //               child: SpinKitChasingDots(
  //                 color: AppColors.secondary,
  //                 size: 60,
  //               ),
  //             );
  //           } else if (snapshot.hasError) {
  //             return Center(
  //               child: Text('Une erreur s\'est produite. Veuillez réessayer.'),
  //             );
  //           } else {
  //             return Padding(
  //               padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
  //               child: Text(
  //                 snapshot.data,
  //                 style: TextStyle(fontSize: 16),
  //               ),
  //             );
  //           }
  //         },
  //       ),
  //     ),
  //   );
  // }

  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Politique de confidentialité"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Politique de confidentialité d'EventOs",
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Dernière mise à jour : $now',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "Introduction",
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Bienvenue sur EventOs, une application développée par un groupe d'étudiants de l'Institut de Formation et de Recherche en Informatique (IFRI). Chez EventOs, nous accordons une grande importance à la protection de la vie privée de nos utilisateurs. Cette politique de confidentialité explique comment nous recueillons, utilisons et partageons vos informations personnelles lorsque vous utilisez notre application.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "Collecte et Utilisation des Informations",
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Lorsque vous utilisez EventOs, nous pouvons collecter certaines informations personnelles, y compris, mais sans s'y limiter, votre nom, votre adresse e-mail, votre numéro de téléphone et des informations de paiement. Ces informations sont utilisées pour traiter vos réservations, vous fournir un accès à des évènements et améliorer notre service.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "Partage d'Informations",
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "EventOs s'engage à ne pas vendre, louer ni partager vos informations personnelles avec des tiers, sauf dans les cas suivants :",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
                "1. Lorsque cela est nécessaire pour traiter une réservation ou un paiement."),
            const Text("2. Lorsque nous sommes légalement tenus de le faire."),
            const Text(
                "3. Lorsque vous consentez explicitement au partage de vos informations."),
            const SizedBox(height: 20),
            Text(
              "Sécurité des Informations",
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "EventOs prend des mesures pour protéger vos informations personnelles. Nous utilisons des protocoles de sécurité pour garantir la confidentialité de vos données. Cependant, aucune méthode de transmission sur Internet ni de stockage électronique n'est totalement sécurisée. Par conséquent, nous ne pouvons pas garantir la sécurité absolue de vos informations.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "Droits des Utilisateurs",
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Vous avez le droit de demander l'accès, la rectification, la suppression ou la portabilité de vos informations personnelles. Vous pouvez également vous opposer au traitement de vos données. Pour exercer ces droits, veuillez nous contacter à l'adresse fournie ci-dessous.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "Contactez-Nous",
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Si vous avez des questions ou des préoccupations concernant notre politique de confidentialité, veuillez nous contacter à l'adresse suivante :",
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              "E-mail : [Adresse e-mail de contact]",
            ),
            const SizedBox(height: 20),
            Text(
              "Changements de la Politique de Confidentialité",
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Nous nous réservons le droit de mettre à jour cette politique de confidentialité à tout moment. Toute modification sera publiée sur notre application. Nous vous encourageons à consulter régulièrement cette politique pour rester informé de la manière dont nous protégeons vos informations.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
