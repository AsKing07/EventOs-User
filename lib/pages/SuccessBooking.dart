import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_project/pages/HomePage.dart';
import 'package:flutter_project/config/config.dart';
import 'package:flutter_project/config/size.dart';
import 'Pass.dart';

class Success extends StatefulWidget {
  final String payment_id;
  final String eventCode;
  final String passCode;
  final bool isOnline;
  const Success(
      {super.key,
      required this.eventCode,
      required this.payment_id,
      required this.passCode,
      required this.isOnline});

  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    var width = SizeConfig.getWidth(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Réservation effectuée",
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Lottie.asset('assets/success.json',
                  width: width * 0.8, repeat: false),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Réservation réussie',
                    style: GoogleFonts.roboto(
                        fontSize: 30, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 10),
              Text(
                'ID de paiement : ${widget.payment_id}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Pass(
                        widget.passCode, widget.eventCode, widget.isOnline);
                  }));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Voir le Pass',
                    style: TextStyle(fontSize: 20, color: Colors.black)),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      ModalRoute.withName("/homepage"));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Aller à la page d\'accueil',
                    style: TextStyle(fontSize: 20, color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
