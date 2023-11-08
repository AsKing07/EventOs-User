import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart';

class Mail {
  void sendMail(String passCode, bool isOnline, String eventCode) async {
    late String? userToken;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    // if (user != null) {
    //   userToken = await user.getIdToken();
    //   print('Token de l\'utilisateur : $userToken');
    // } else {
    //   print('L\'utilisateur n\'est pas connecté.');
    // }

    late DocumentSnapshot passDetails;

    if (isOnline) {
      passDetails = await FirebaseFirestore.instance
          .collection('OnlineEvents')
          .doc(eventCode)
          .collection('guests')
          .doc(passCode)
          .get();
    } else {
      passDetails = await FirebaseFirestore.instance
          .collection('events')
          .doc(eventCode)
          .collection('guests')
          .doc(passCode)
          .get();
    }

    late DocumentSnapshot<Map<String, dynamic>> x;
    if (isOnline) {
      x = await FirebaseFirestore.instance
          .collection('OnlineEvents')
          .doc(eventCode)
          .get();
    } else {
      x = await FirebaseFirestore.instance
          .collection('events')
          .doc(eventCode)
          .get();
    }

    final email = user?.email;
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/qr_code.png');

    ByteData? qrBytes = await QrPainter(
      data: "Code du pass: $passCode; ",
      gapless: true,
      version: QrVersions.auto,
      color: Color.fromRGBO(148, 176, 194, 1),
      emptyColor: Colors.white,
    ).toImageData(878);

    final buffer = qrBytes!.buffer.asUint8List();
    await file.writeAsBytes(buffer);

    final htmlContent = '''
<!DOCTYPE html>
<html>
 
 <head>
  <meta charset="UTF-8">
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #000;
      color: #000;
    }

    .texte{
       width: 100%;
       color: black;
    }

    .ticket {
      width: 100%;
      height: 1110px;
      background-color: #fff;
      border-radius: 10px;
      padding: 20px;
    }
    .ticket .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .ticket .header .class {
      width: 200px;
      height: 32px;
      border-radius: 30px;
      border: 1px solid #00FF00;
      display: flex;
      justify-content: center;
      align-items: center;
      color: #00FF00;
    }
    .ticket .header .eventos {
      display: flex;
      align-items: center;
    }
    .ticket .header .eventos .baseName {
      font-weight: bold;
      color: #000;
    }
    .ticket .header .eventos .icon {
      color: #FF00FF;
      margin-left: 8px;
    }
    .ticket .header .eventos .afterName {
      font-weight: bold;
      color: #000;
    }
    .ticket .title {
      color: #000;
      font-size: 20px;
      font-weight: bold;
      margin-top: 20px;
    }
    .ticket .details {
      margin-top: 25px;
    }
    .ticket .details .row {
      width: 100%
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 12px;
    }
    .ticket .details .row .title {
      color: #808080;
    }
    .ticket .details .row .desc {
      color: #000;
    }
    .ticket .barcode {
      width: 250px;
      height: 60px;
      margin-top: 80px;
      margin-left: 30px;
      margin-right: 30px;
    }
  </style>
</head>
<body>
<div class="texte"> 
 <p>Veuillez trouver ci-joint votre QR Code pour accéder à l'événement. 
            Votre QR Code reste cependant disponible via l'application </p> 
            <p>Ce code QR Code sera scanné à votre présentation à l'évènement </p>
             <p>Une fois scanné, il n'est plus utilisable. Veuillez donc bien le conservé 

</div>
 
  <div class="ticket">

    <div class="header">
      <div class="class">
      ${x.data()!['eventCategory']}
      </div>
      <div class="eventos">
        <span class="baseName">Event</span>
        <span class="icon">🎉</span>
        <span class="afterName">Os</span>
      </div>
    </div>

    <h1 class="title">Ticket ${x.data()!['eventName']}</h1>
    <div class="details">
      <div class="row">
        <div class="title">Identité:</div>
        <div class="desc">${user!.displayName ?? ''}</div>
      </div>
      <div class="row">
        <div class="title">Date:</div>
        <div class="desc">${DateFormat('EEEE dd MMM yyy à hh:mm').format(x.data()!['eventDateTime'].toDate())}</div>
      </div>
      <div class="row">
        <div class="title">Evènement</div>
        <div class="desc">${x.data()!['eventName']}</div>
      </div>
      <div class="row">
        <div class="title">Lieu</div>
        <div class="desc">${isOnline ? "En ligne" : x.data()!['position'] + " " + x.data()!['eventAddress']}</div>
      </div>
      <div class="row">
        <div class="title">Catégorie</div>
        <div class="desc">${x.data()!['eventCategory']}</div>
      </div>
      <div class="row">
        <div class="title">Nombre de personne(s):</div>
        <div class="desc">${passDetails['ticketCount']}</div>
      </div>
      <div class="row">
        <div class="title">Organisateurs:</div>
        <div class="desc"><br>Tel:${x.data()!['hostPhoneNumber']} <br> Email:${x.data()!['hostEmail']}</div>
      </div>
    </div>  
    </div>
</body>
</html>
''';

    var filePath = '${tempDir.path}/pass_pdf.pdf';
    var pfile = File(filePath);
    final newpdf = Document(author: "EventOs", title: "PASS");
    List<pw.Widget> widgets =
        await HTMLToPdf().convert(htmlContent, defaultFont: Font.courierBold());
    final image = pw.MemoryImage(file.readAsBytesSync());
    widgets.add(pw.Center(
      child: pw.Image(image),
    ));

    newpdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Container(
            child: pw.Column(
              children: [
                ...widgets,
              ],
            ),
          ),
        ],
      ),
    );

    await pfile.writeAsBytes(await newpdf.save());

    if (email != null) {
      final server = gmail('charbelsnn@gmail.com', 'cybnxrgfsydiyrtw');

      final message = Message()
        ..from = Address('charbelsnn@gmail.com', 'L\'Equipe EventOs')
        ..recipients.add(email)
        ..subject = 'Votre Pass Evènement'
        ..html = '''
           
<head>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #000;
      color: #000;
    }

    .texte{
       width: 100%;
       color: black;
    }

    .ticket {
      width: 100%;
      height: 1110px;
      background-color: #fff;
      border-radius: 10px;
      padding: 20px;
    }
    .ticket .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .ticket .header .class {
      width: 200px;
      height: 32px;
      border-radius: 30px;
      border: 1px solid #00FF00;
      display: flex;
      justify-content: center;
      align-items: center;
      color: #00FF00;
    }
    .ticket .header .eventos {
      display: flex;
      align-items: center;
    }
    .ticket .header .eventos .baseName {
      font-weight: bold;
      color: #000;
    }
    .ticket .header .eventos .icon {
      color: #FF00FF;
      margin-left: 8px;
    }
    .ticket .header .eventos .afterName {
      font-weight: bold;
      color: #000;
    }
    .ticket .title {
      color: #000;
      font-size: 20px;
      font-weight: bold;
      margin-top: 20px;
    }
    .ticket .details {
      margin-top: 25px;
    }
    .ticket .details .row {
      width: 100%
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 12px;
    }
    .ticket .details .row .title {
      color: #808080;
    }
    .ticket .details .row .desc {
      color: #000;
    }
    .ticket .barcode {
      width: 250px;
      height: 60px;
      margin-top: 80px;
      margin-left: 30px;
      margin-right: 30px;
    }
  </style>
</head>
<body>
<div class="texte"> 
 <p>Veuillez trouver ci-joint votre QR Code pour accéder à l'événement. 
            Votre QR Code reste cependant disponible via l'application </p> 
            <p>Ce code QR Code sera scanné à votre présentation à l'évènement </p>
             <p>Une fois scanné, il n'est plus utilisable. Veuillez donc bien le conservé 

</div>
 
  <div class="ticket">

    <div class="header">
      <div class="class">
      ${x.data()!['eventCategory']}
      </div>
      <div class="eventos">
        <span class="baseName">Event</span>
        <span class="icon">🎉</span>
        <span class="afterName">Os</span>
      </div>
    </div>

    <h1 class="title">Ticket ${x.data()!['eventName']}</h1>
    <div class="details">
      <div class="row">
        <div class="title">Identité:</div>
        <div class="desc">${user.displayName ?? ''}</div>
      </div>
      <div class="row">
        <div class="title">Date:</div>
        <div class="desc">${DateFormat('EEEE dd MMM yyy à hh:mm').format(x.data()!['eventDateTime'].toDate())}</div>
      </div>
      <div class="row">
        <div class="title">Evènement</div>
        <div class="desc">${x.data()!['eventName']}</div>
      </div>
      <div class="row">
        <div class="title">Lieu</div>
        <div class="desc">${isOnline ? "En ligne" : x.data()!['position'] + " " + x.data()!['eventAddress']}</div>
      </div>
      <div class="row">
        <div class="title">Catégorie</div>
        <div class="desc">${x.data()!['eventCategory']}</div>
      </div>
      <div class="row">
        <div class="title">Nombre de personne(s):</div>
        <div class="desc">${passDetails['ticketCount']}</div>
      </div>
      <div class="row">
        <div class="title">Organisateurs:</div>
        <div class="desc"><br>Tel:${x.data()!['hostPhoneNumber']} <br> Email:${x.data()!['hostEmail']}</div>
      </div>
        <div class="row">
    <a href="cid:pdf_file">Voir le PDF</a>
    </div>   
       <div class="barcode">
       <div class="title">
       <img src="cid:qr_code_image" alt="QRCode">
       </div>
    
    </div>   
     
    </div>  
    </div>
</body>
            '''
        ..attachments.add(
          FileAttachment(File(file.path))
            ..location = Location.inline
            ..cid = '<qr_code_image>',
        )
        ..attachments.add(
          FileAttachment(pfile)
            ..location = Location.inline
            ..cid = '<pdf_file>',
        );

      try {
        final sendReport = await send(message, server);
        print('Message envoyé: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message non envoyé.');
        for (var p in e.problems) {
          print('Problemes: ${p.code}: ${p.msg}');
        }
      }
    }
  }
}
