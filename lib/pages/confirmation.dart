// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_project/config/config.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_fluid_slider_nnbd/flutter_fluid_slider_nnbd.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_project/Methods/getPass.dart';
// import 'package:flutter_project/pages/SuccessBooking.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// // ignore: must_be_immutable
// class BuyTicket extends StatefulWidget {
//   DocumentSnapshot post;
//   BuyTicket(this.post, {super.key});
//   @override
//   _BuyTicketState createState() => _BuyTicketState();
// }

// class _BuyTicketState extends State<BuyTicket> {
//   final Razorpay _razorpay = Razorpay();
//   int _ticketCount = 1;
//   double _value = 1.0;

//   @override
//   void initState() {
//     super.initState();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _razorpay.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Stack(
//           children: <Widget>[
//             SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(top: 15.0, left: 15.0),
//                     child: Row(
//                       children: <Widget>[
//                         Container(
//                           width: MediaQuery.of(context).size.width * .12,
//                           height: MediaQuery.of(context).size.width * .12,
//                           child: IconButton(
//                               icon: const Icon(
//                                 Icons.keyboard_arrow_left,
//                                 size: 28.0,
//                               ),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               }),
//                         ),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * .75,
//                           child: Text(
//                             widget.post['eventName'] ?? '',
//                             style: TextStyle(
//                                 fontSize: 30,
//                                 fontWeight: FontWeight.w900,
//                                 letterSpacing: 1.5,
//                                 color: AppColors.primary),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 15, bottom: 12),
//                       child: Text('Prix par Pass',
//                           style: GoogleFonts.cabin(
//                             fontWeight: FontWeight.w800,
//                             fontSize: 25,
//                             color: const Color(0xff1E0A3C),
//                           )),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                         padding: const EdgeInsets.only(
//                           left: 15,
//                         ),
//                         child: Text(
//                             '₹ ${widget.post['isPaid'] ? widget.post['ticketPrice'] ?? 'Free' : 'Free'}',
//                             style: GoogleFonts.mavenPro(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 22,
//                               color: const Color(0xff39364f),
//                             ))),
//                   ),
//                   const SizedBox(height: 10),
//                   const Divider(thickness: 1),
//                   const SizedBox(height: 8),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 15, bottom: 12),
//                       child: Text('Date et heure',
//                           style: GoogleFonts.cabin(
//                             fontWeight: FontWeight.w800,
//                             fontSize: 25,
//                             color: const Color(0xff1E0A3C),
//                           )),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                         left: 15,
//                       ),
//                       child: Text(
//                           '${DateFormat('EEE, d MMMM yyyy').format(widget.post['eventDateTime']?.toDate() ?? DateTime.now())} at ${DateFormat('hh:mm a').format(widget.post['eventDateTime']?.toDate() ?? DateTime.now())}',
//                           style: GoogleFonts.mavenPro(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16,
//                             color: const Color(0xff39364f),
//                           )),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const Divider(thickness: 1),
//                   const SizedBox(height: 8),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 15, bottom: 12),
//                       child: Text('Addresse',
//                           style: GoogleFonts.cabin(
//                             fontWeight: FontWeight.w800,
//                             fontSize: 25,
//                             color: const Color(0xff1E0A3C),
//                           )),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                         left: 15,
//                       ),
//                       child: Text(
//                           widget.post['isOnline'] ?? false
//                               ? 'Evenement en cours'
//                               : widget.post['eventAddress'] ?? '',
//                           style: GoogleFonts.mavenPro(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16,
//                             color: const Color(0xff39364f),
//                           )),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const Divider(thickness: 1),
//                   const SizedBox(height: 8),
//                   widget.post['isPaid'] ?? false
//                       ? Align(
//                           alignment: Alignment.centerLeft,
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.only(left: 15, bottom: 12),
//                             child: Text('Combien de tickets?',
//                                 style: GoogleFonts.cabin(
//                                   fontWeight: FontWeight.w800,
//                                   fontSize: 25,
//                                   color: const Color(0xff1E0A3C),
//                                 )),
//                           ),
//                         )
//                       : Container(),
//                   widget.post['isPaid'] ?? false
//                       ? Center(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 15),
//                             child: FluidSlider(
//                               sliderColor: AppColors.tertiary,
//                               thumbColor: AppColors.primary,
//                               valueTextStyle:
//                                   const TextStyle(color: Colors.white),
//                               value: _value,
//                               showDecimalValue: false,
//                               onChanged: (double newValue) {
//                                 setState(() {
//                                   _value = newValue;
//                                   _ticketCount = newValue.toInt();
//                                 });
//                               },
//                               min: 1.0,
//                               max: 10.0,
//                             ),
//                           ),
//                         )
//                       : Container(),
//                 ],
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(left: 25.0, bottom: 10.0),
//                     child: Text(
//                       widget.post['isPaid'] ?? false
//                           ? ' ${widget.post['ticketPrice'] * _ticketCount}'
//                           : 'GRATUIT',
//                       style: const TextStyle(
//                           fontSize: 30.0,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () async {
//                       if (widget.post['isPaid'] ?? false) {
//                         openCheckout(
//                             (widget.post['ticketPrice'] ?? 0) * _ticketCount);
//                       } else {
//                         //Partie à revoir
//                         PaymentSuccessResponse reponse = PaymentSuccessResponse(
//                             "paymentId", "orderId", "signature");
//                         await GetPass()
//                             .bookPass(widget.post, _ticketCount, reponse)
//                             .then((value) {
//                           Navigator.pushAndRemoveUntil(context,
//                               MaterialPageRoute(builder: (context) {
//                             return Success(
//                               passCode: value,
//                               eventCode: widget.post['eventCode'] ?? '',
//                               payment_id: '',
//                               isOnline: widget.post['isOnline'] ?? false,
//                             );
//                           }), ModalRoute.withName("/homepage"));
//                         });
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 40.0, vertical: 10.0),
//                       width: 150,
//                       height: 50,
//                       decoration: BoxDecoration(
//                           color: AppColors.secondary,
//                           borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(25.0))),
//                       child: const Center(
//                           child: Text('Payer',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 25.0,
//                                   fontWeight: FontWeight.bold))),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void openCheckout(double amount) async {
//     var options = {
//       'key': 'rzp_test_df25oDEIBVWDyE',
//       'amount': double.parse(amount.toStringAsFixed(2)) * 100.toInt(),
//       "currency": "XOF",
//       'name': widget.post['eventName'] ?? '',
//       'description':
//           '${DateFormat('EEE, d MMMM yyyy').format(widget.post['eventDateTime']?.toDate() ?? DateTime.now())} at ${DateFormat('hh:mm a').format(widget.post['eventDateTime']?.toDate() ?? DateTime.now())}',
//     };
//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint(e as String?);
//     }
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     Fluttertoast.showToast(
//       backgroundColor: Colors.green,
//       textColor: Colors.white,
//       msg: "SUCCESS: ${response.paymentId}",
//     );
//     await GetPass().bookPass(widget.post, _ticketCount, response).then((value) {
//       Navigator.pushAndRemoveUntil(context,
//           MaterialPageRoute(builder: (context) {
//         return Success(
//           passCode: value,
//           eventCode: widget.post['eventCode'] ?? '',
//           payment_id: response.paymentId!,
//           isOnline: widget.post['isOnline'] ?? false,
//         );
//       }), ModalRoute.withName("/homepage"));
//     });
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     Fluttertoast.showToast(
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       msg: "ERROR: ${response.code} - ${response.message}",
//     );
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     Fluttertoast.showToast(
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       msg: "EXTERNAL_WALLET: ${response.walletName}",
//     );
//   }
// }

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/Methods/getUserId.dart';
import 'package:flutter_project/config/config.dart';
import 'package:flutter_project/pages/Pass.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_fluid_slider_nnbd/flutter_fluid_slider_nnbd.dart';
import 'package:intl/intl.dart';
import 'package:flutter_project/Methods/getPass.dart';
import 'package:flutter_project/pages/SuccessBooking.dart';
import 'package:kkiapay_flutter_sdk/kkiapay/view/widget_builder_view.dart';
import 'package:flutter_project/pages/AbandonBooking.dart';
import 'package:kkiapay_flutter_sdk/utils/kkiapayConf.sample.dart';

class BuyTicket extends StatefulWidget {
  DocumentSnapshot post;
  BuyTicket(this.post, {super.key});
  @override
  _BuyTicketState createState() => _BuyTicketState();
}

class _BuyTicketState extends State<BuyTicket> {
  int _ticketCount = 1;
  double _value = 1.0;

  // late Map<String, dynamic> response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  // ... Rest of the code
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 15.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * .12,
                          height: MediaQuery.of(context).size.width * .12,
                          child: IconButton(
                              icon: const Icon(
                                Icons.keyboard_arrow_left,
                                size: 28.0,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .75,
                          child: Text(
                            widget.post['eventName'] ?? '',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                                color: AppColors.primary),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 12),
                      child: Text('Prix par Pass',
                          style: GoogleFonts.cabin(
                            fontWeight: FontWeight.w800,
                            fontSize: 25,
                            color: const Color(0xff1E0A3C),
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                        ),
                        child: Text(
                            '${widget.post['isPaid'] ? widget.post['ticketPrice'] ?? 'Free' : 'Free'}',
                            style: GoogleFonts.mavenPro(
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                              color: const Color(0xff39364f),
                            ))),
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 1),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 12),
                      child: Text('Date et heure',
                          style: GoogleFonts.cabin(
                            fontWeight: FontWeight.w800,
                            fontSize: 25,
                            color: const Color(0xff1E0A3C),
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                      ),
                      child: Text(
                          '${DateFormat('EEE, d MMMM yyyy').format(widget.post['eventDateTime']?.toDate() ?? DateTime.now())} at ${DateFormat('hh:mm a').format(widget.post['eventDateTime']?.toDate() ?? DateTime.now())}',
                          style: GoogleFonts.mavenPro(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: const Color(0xff39364f),
                          )),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 1),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 12),
                      child: Text('Addresse',
                          style: GoogleFonts.cabin(
                            fontWeight: FontWeight.w800,
                            fontSize: 25,
                            color: const Color(0xff1E0A3C),
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                      ),
                      child: Text(
                          widget.post['isOnline'] ?? false
                              ? 'Evenement en ligne'
                              : widget.post['eventAddress'] ?? '',
                          style: GoogleFonts.mavenPro(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: const Color(0xff39364f),
                          )),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 1),
                  const SizedBox(height: 8),
                  widget.post['isPaid'] ?? false
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 15, bottom: 12),
                            child: Text('Nombre de personnes?',
                                style: GoogleFonts.cabin(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 25,
                                  color: const Color(0xff1E0A3C),
                                )),
                          ),
                        )
                      : Container(),
                  widget.post['isPaid'] ?? false
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: FluidSlider(
                              sliderColor: AppColors.tertiary,
                              thumbColor: AppColors.primary,
                              valueTextStyle:
                                  const TextStyle(color: Colors.white),
                              value: _value,
                              showDecimalValue: false,
                              onChanged: (double newValue) {
                                setState(() {
                                  _value = newValue;
                                  _ticketCount = newValue.toInt();
                                });
                              },
                              min: 1.0,
                              max: 10.0,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, bottom: 10.0),
                    child: Text(
                      widget.post['isPaid'] ?? false
                          ? ' ${widget.post['ticketPrice'] * _ticketCount}'
                          : 'GRATUIT',
                      style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (widget.post['isPaid'] ?? false) {
                        openCheckout(
                            (widget.post['ticketPrice'] ?? 0) * _ticketCount);
                      } else {
                        //Generer un id de transaction aléatoire utilisant la fonction random
                        int transactionId = Random().nextInt(5);
                        await GetPass()
                            .bookPass(widget.post, _ticketCount,
                                transactionId.toString())
                            .then((value) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return Success(
                                passCode: value,
                                eventCode: widget.post['eventCode'] ?? '',
                                payment_id: '',
                                isOnline: widget.post['isOnline'] ?? false,
                              );
                            }),
                            ModalRoute.withName("/homepage"),
                          );
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 10.0),
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Payer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openCheckout(double amount) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final User? currentUser = await _auth.currentUser;

    String userName = currentUser!.displayName!;

    final kkiapay = KKiaPay(
        callback: sucessCallback,
        // callback: (response, context) async {
        //   String paymentId = response['data']['transactionId'];
        //   String status = response['name'];
        //   String data = response['data']['transactionId'];
        //   Navigator.pop(context);

        //   switch (status) {
        //     case 'PAYMENT_CANCELLED':
        //       String abandonText = "Payement annulé: $paymentId \n $data";

        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => AbandonBooking(
        //                 paymentId: paymentId, abandonText: abandonText)),
        //       );
        //       break;
        //     case 'CLOSE_WIDGET':
        //       String abandonText = "Payement annulé: $paymentId \n $data";

        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => AbandonBooking(
        //                 paymentId: paymentId, abandonText: abandonText)),
        //       );
        //       break;

        //     case 'PAYMENT_SUCCESS':
        //       await GetPass()
        //           .bookPass(widget.post, _ticketCount, response)
        //           .then((value) {
        //         Navigator.pushAndRemoveUntil(
        //           context,
        //           MaterialPageRoute(builder: (context) {
        //             return Success(
        //               passCode: value,
        //               eventCode: widget.post['eventCode'] ?? '',
        //               payment_id: paymentId,
        //               isOnline: widget.post['isOnline'] ?? false,
        //             );
        //           }),
        //           ModalRoute.withName("/homepage"),
        //         );
        //       });
        //       break;
        //     case 'PAYMENT_FAILED':
        //       String abandonText = "Echec du payement: $paymentId \n $data";
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => AbandonBooking(
        //                 paymentId: paymentId, abandonText: abandonText)),
        //       );
        //       break;

        //     default:
        //       String abandonText = "Echec du payement: $paymentId \n $data";
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => AbandonBooking(
        //                 paymentId: paymentId, abandonText: abandonText)),
        //       );
        //       break;
        //   }
        // },
        amount: amount.toInt(),
        apikey: '74707e40729f11eea29bd729ceb25af7',
        sandbox: true,
        email: currentUser.email,
        reason:
            'Achat de pass pour l\'évènement ${widget.post['eventName']}   \n Code:  ${widget.post['eventCode']} \n Organisateur: ${widget.post['hostName']} .',
        data: 'Achat de pass pour l\'évènement ${widget.post['eventName']}   \n Code:  ${widget.post['eventCode']} \n Organisateur: ${widget.post['hostName']} .',
        phone: currentUser.phoneNumber,
        name: userName,
        theme: '#2ba359',
        countries: const ["BJ"],
        paymentMethods: const ["momo"]);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => kkiapay),
    );
  }

  void sucessCallback(response, context) async {
    // Navigator.pop(context);
    print(response);

    String status = response['status'];
    String data = response['requestData']['data'];

    switch (status) {
      case 'PAYMENT_CANCELLED':
        try {
          String abandonText = "Le Payement a été annulé: $status \n $data";

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AbandonBooking(
                    paymentId: "Non disponible", abandonText: abandonText)),
          );
        } catch (e) {
          SnackBar(
            content: Text(e.toString()),
          );
        }

        break;

      case 'CLOSE_WIDGET':
        try {
          String abandonText = "Le Payement a été annulé: $status \n $data";

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AbandonBooking(
                    paymentId: "Non disponible", abandonText: abandonText)),
          );
        } catch (e) {
          SnackBar(
            content: Text(e.toString()),
          );
        }

        break;

      case 'PAYMENT_SUCCESS':
        try {
          String paymentId = response['transactionId'];

          await GetPass()
              .bookPass(widget.post, _ticketCount, paymentId)
              .then((value) {
            Pass pass = Pass(value, widget.post['eventCode'] ?? "",
                widget.post['isOnline'] ?? false);
            pass.sendMail();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Success(
                      eventCode: widget.post['eventCode'] ?? " ",
                      payment_id: paymentId,
                      passCode: value,
                      isOnline: widget.post['isOnline'] ?? false)),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) {
                return Success(
                  passCode: value,
                  eventCode: widget.post['eventCode'] ?? '',
                  payment_id: paymentId,
                  isOnline: widget.post['isOnline'] ?? false,
                );
              }),
              ModalRoute.withName("/homepage"),
            );
          });
        } catch (e) {
          SnackBar(
            content: Text(e.toString()),
          );
        }

        break;

      case 'PAYMENT_FAILED':
        try {
          String paymentId = response['transactionId'];

          String donnee =
              'Achat de pass pour l\'évènement ${widget.post['eventName']}   \n Code:  ${widget.post['eventCode']} \n Organisateur: ${widget.post['hostName']} .';

          String abandonText = "Echec du payement: $status \n $donnee";
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AbandonBooking(
                    paymentId: paymentId, abandonText: abandonText)),
          );
        } catch (e) {
          SnackBar(
            content: Text(e.toString()),
          );
        }

        break;

      default:
        try {
          String donnee =
              'Achat de pass pour l\'évènement ${widget.post['eventName']}   \n Code:  ${widget.post['eventCode']} \n Organisateur: ${widget.post['hostName']} .';
          String abandonText = "Echec du payement: $status \n $donnee";
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AbandonBooking(
                    paymentId: 'Non disponible', abandonText: abandonText)),
          );
        } catch (e) {
          SnackBar(
            content: Text(e.toString()),
          );

          break;
        }
    }
  }
}
