import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_project/Widgets/eventCard.dart';
import 'package:flutter_project/config/config.dart';
import 'package:flutter_project/config/size.dart';
import 'package:flutter_svg/svg.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Stream? q;
  TextEditingController searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  bool isOnline = false;
  String currentVal = "Online Events";
  onSearch(String val) {
    setState(() {
      if (isOnline) {
        q = FirebaseFirestore.instance
            .collection('OnlineEvents')
            .where('eventNameArr', arrayContains: val.toLowerCase())
            .snapshots();
      } else {
        q = FirebaseFirestore.instance
            .collection('events')
            .where('eventNameArr', arrayContains: val.toLowerCase())
            .snapshots();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.getHeight(context);
    double width = SizeConfig.getWidth(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: <Widget>[
          Container(
              margin: EdgeInsets.only(
                  left: width / 15,
                  top: height / 15,
                  right: width / 15,
                  bottom: height / 30),
              width: width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recherche',
                        style: GoogleFonts.lora(
                            fontSize: 35,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary),
                      ),
                      Text('Par nom',
                          style: GoogleFonts.lora(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondary,
                              fontStyle: FontStyle.italic)),
                    ],
                  ),
                  DropdownButton(
                      value: currentVal,
                      hint: const Text('Offline Events'),
                      items: [
                        DropdownMenuItem(
                            value: 'Offline Events',
                            child: const Text('Présentiel'),
                            onTap: () {
                              setState(() {
                                isOnline = false;
                              });
                            }),
                        DropdownMenuItem(
                            value: 'Online Events',
                            child: const Text('En ligne'),
                            onTap: () {
                              setState(() {
                                isOnline = true;
                              });
                            })
                      ],
                      onChanged: (val) {
                        setState(() {
                          currentVal = val!;
                        });
                      })
                ],
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher',
                hintStyle: GoogleFonts.lora(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                helperText: 'Entrez le nom de l\'évènement que vous recherchez',
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black)),
              ),
              onChanged: (val) {
                _debouncer.run(() {
                  onSearch(val);
                });
                print(searchController.text);
              },
            ),
          ),
          StreamBuilder(
              stream: q,
              builder: (context, snapshot) {
                // ignore: unnecessary_null_comparison
                if (searchController.text == null ||
                    searchController.text == '') {
                  print('yo');
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Container(
                          child: SvgPicture.asset('assets/search.svg',
                              width: width * 0.6,
                              semanticsLabel: 'Event Illustration'),
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.connectionState ==
                        ConnectionState.waiting ||
                    !snapshot.hasData)
                  return SpinKitChasingDots(color: AppColors.secondary);
                else {
                  if (snapshot.data.docs.length == 0) {
                    print(2);
                    return const Text('Pas de résultats',
                        style: TextStyle(
                          color: Colors.black,
                        ));
                  } else {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            print(1);
                            return eventCard(snapshot.data.docs[index], height,
                                width, 0, context);
                          }),
                    );
                  }
                }
              })
        ]));
  }
}

class Debouncer {
  final int milliseconds;
  late VoidCallback action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    // ignore: unnecessary_null_comparison
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
