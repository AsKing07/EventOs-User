import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_project/Widgets/eventCard.dart';
import 'package:flutter_project/config/size.dart';
import '../config/config.dart';

class JoinedEvents extends StatefulWidget {
  final String uid;
  JoinedEvents(this.uid);
  @override
  _JoinedEventsState createState() => _JoinedEventsState();
}

class _JoinedEventsState extends State<JoinedEvents>
    with SingleTickerProviderStateMixin {
  var firestore = FirebaseFirestore.instance;
  late TabController _tabController;
  int index = 0;
  Future getEvents(int index) async {
    List<String> eventCodes = [];
    if (index == 0) {
      final QuerySnapshot result = await firestore
          .collection('users')
          .doc(widget.uid)
          .collection('eventJoined')
          .get();
      result.docs.forEach((element) => eventCodes.add(element['eventCode']));
      if (eventCodes.isNotEmpty) {
        final QuerySnapshot joinedEventDetails = await firestore
            .collection('events')
            .orderBy('eventDateTime', descending: false)
            .where("eventCode", whereIn: eventCodes)
            .get();
        return joinedEventDetails.docs;

        // Traitement des résultats ici
      } else {
        // Gérer le cas où eventCodes est vide, par exemple, afficher un message d'erreur ou effectuer une action appropriée.
      }
    } else {
      final QuerySnapshot result = await firestore
          .collection('users')
          .doc(widget.uid)
          .collection('eventJoined')
          .get();
      result.docs.forEach((element) => eventCodes.add(element['eventCode']));
      if (eventCodes.isNotEmpty) {
        final QuerySnapshot joinedEventDetails = await firestore
            .collection('OnlineEvents')
            .orderBy('eventDateTime', descending: true)
            .where("eventCode", whereIn: eventCodes)
            .get();
        return joinedEventDetails.docs;
      } else {}
    }
  }

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.getHeight(context);
    double width = SizeConfig.getWidth(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Image.asset(
            'assets/logo.png',
            height: 50,
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.red,
            indicatorColor: AppColors.tertiary,
            tabs: const <Tab>[
              Tab(text: 'Evenements en présentiel'),
              Tab(text: 'Evenements en ligne'),
            ],
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(right: 16.0, bottom: 10.0, top: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Evenements auquels vous participez",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: AppColors.primary),
                  ),
                ),
              ),
              FutureBuilder(
                  future: getEvents(_tabController.index),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Expanded(
                          child: Center(
                              child: SpinKitChasingDots(
                                  color: AppColors.secondary, size: 40)));
                    } else if (snapshot.data == null) {
                      return Column(
                        children: [
                          Container(
                            width: width,
                            height: height / 2,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SvgPicture.asset('assets/event.svg',
                                    semanticsLabel: 'Illustration'),
                              ),
                            ),
                          ),
                          SizedBox(height: height / 20),
                          const Text("Rien à montrer ici :(")
                        ],
                      );
                    } else {
                      if (snapshot.data.length == 0) {
                        return Column(
                          children: [
                            Container(
                              width: width,
                              height: height / 2,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SvgPicture.asset('assets/event.svg',
                                      semanticsLabel: ' Illustration'),
                                ),
                              ),
                            ),
                            SizedBox(height: height / 20),
                            const Text("Rien à montrer ici :(")
                          ],
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return eventCard(snapshot.data[index], height,
                                    width, 2, context);
                              }),
                        );
                      }
                    }
                  }),
            ],
          ),
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(right: 16.0, bottom: 10.0, top: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Evenements auquels vous participez",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: AppColors.primary),
                  ),
                ),
              ),
              FutureBuilder(
                  future: getEvents(_tabController.index),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Expanded(
                          child: Center(
                              child: SpinKitChasingDots(
                                  color: AppColors.secondary, size: 40)));
                    } else if (snapshot.data == null) {
                      return Column(
                        children: [
                          Container(
                            width: width,
                            height: height / 2,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SvgPicture.asset('assets/event.svg',
                                    semanticsLabel: 'Illustration'),
                              ),
                            ),
                          ),
                          SizedBox(height: height / 20),
                          Text("Rien à montrer ici :(")
                        ],
                      );
                    } else {
                      if (snapshot.data.length == 0) {
                        return Column(
                          children: [
                            Container(
                              width: width,
                              height: height / 2,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SvgPicture.asset('assets/event.svg',
                                      semanticsLabel: 'Illustration'),
                                ),
                              ),
                            ),
                            SizedBox(height: height / 20),
                            const Text("Rien à montrer ici :(")
                          ],
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return eventCard(snapshot.data[index], height,
                                    width, 2, context);
                              }),
                        );
                      }
                    }
                  }),
            ],
          ),
        ]));
  }
}
