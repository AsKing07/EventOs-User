import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_project/pages/HomePage.dart';
import 'package:flutter_project/config/config.dart';
import 'package:flutter_project/config/size.dart';

class AbandonBooking extends StatelessWidget {
  final String paymentId;
  final String abandonText;

  AbandonBooking({required this.paymentId, required this.abandonText});

  @override
  Widget build(BuildContext context) {
    var width = SizeConfig.getWidth(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Réservation annulée",
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Lottie.asset('assets/cancel.json',
                  width: width * 0.8, repeat: false),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Abandon de la Réservation',
                    style: GoogleFonts.roboto(
                        fontSize: 30, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 10),
              Text(
                'ID de paiement : $paymentId',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Revenir à la page précédente',
                    style: TextStyle(fontSize: 20, color: Colors.black)),
              ),
              const SizedBox(height: 10),
              Text(
                abandonText,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
