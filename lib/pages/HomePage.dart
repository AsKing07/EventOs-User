// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/pages/AboutUs.dart';
import 'package:flutter_project/pages/EventDetails.dart';
import 'package:flutter_project/pages/JoinedEvents.dart';
import 'package:flutter_project/Methods/getUserId.dart';
import 'package:flutter_project/config/size.dart';
import 'package:flutter_project/Methods/googleSignIn.dart';
import 'package:flutter_project/pages/loginui.dart';
import 'package:flutter_project/pages/policy.dart';
import 'package:flutter_project/pages/search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
// import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:geocoding/geocoding.dart';
import 'package:getwidget/getwidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  static const kInitialPosition = LatLng(2.4144192, 6.3752311);
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late DocumentReference userRef;
  late String name = "", email = "";
  String uid = "";
  late int _selectedIndex = 0;
  late Position location;
  GeoFirePoint? firePoint;
  late List<Placemark> placemark;
  // late Flushbar flush;
  String city = 'Cotonou';
  late FancyDrawerController _controller;
  GeoFlutterFire geo = GeoFlutterFire();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String selectedCat = "All Events";

  List<DropdownMenuItem> categoryList = [
    DropdownMenuItem(
      value: 'All Events',
      child: Text(
        'Tous les évènements',
        style: GoogleFonts.cabin(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: AppColors.primary),
      ),
    ),
    DropdownMenuItem(
      value: 'Appearance/Singing',
      child: Text(
        'Apparition/Chant',
        style: GoogleFonts.cabin(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: AppColors.primary),
      ),
    ),
    DropdownMenuItem(
      value: 'Attaraction',
      child: Text(
        'Attirance',
        style: GoogleFonts.cabin(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: AppColors.primary),
      ),
    ),
    DropdownMenuItem(
      value: 'Camp, Trip or Retreat',
      child: Text(
        'Camp, voyage ou retraite',
        style: GoogleFonts.cabin(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: AppColors.primary),
      ),
    ),
    DropdownMenuItem(
      value: 'Class, Training, or Workshop',
      child: Text(
        'Cours, formation ou atelier',
        style: GoogleFonts.cabin(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: AppColors.primary),
      ),
    ),
    DropdownMenuItem(
      value: 'Concert/Performance',
      child: Text(
        'Concert/Performance',
        style: GoogleFonts.cabin(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: AppColors.primary),
      ),
    ),
    DropdownMenuItem(
      value: 'Conference',
      child: Text(
        'Conférence',
        style: GoogleFonts.cabin(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: AppColors.primary),
      ),
    ),
    DropdownMenuItem(
      value: 'Convention',
      child: Text(
        'Convention',
        style: GoogleFonts.cabin(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: AppColors.primary),
      ),
    ),
    DropdownMenuItem(
      value: 'Dinner or Gala',
      child: Text(
        'Dinner ou Gala',
        style: GoogleFonts.cabin(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: AppColors.primary),
      ),
    ),
    DropdownMenuItem(
      value: 'Festival or Fair',
      child: Text(
        'Festival ou foire',
        style: GoogleFonts.cabin(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: AppColors.primary),
      ),
    ),
    DropdownMenuItem(
      value: 'Game or Competition',
      child: Text(
        'Jeu ou Compétition',
        style: GoogleFonts.cabin(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: AppColors.primary),
      ),
    ),
    DropdownMenuItem(
      value: 'Meeting/Networking event',
      child: Text(
        'Meeting/réseautage',
        style: GoogleFonts.cabin(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: AppColors.primary),
      ),
    ),
    DropdownMenuItem(
      value: 'Party/Social Gathering',
      child: Text(
        'Fête/rassemblement social',
        style: GoogleFonts.cabin(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: AppColors.primary),
      ),
    ),
    DropdownMenuItem(
      value: 'Other',
      child: Text(
        'Autre',
        style: GoogleFonts.cabin(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: AppColors.primary),
      ),
    ),
  ];

  void getUser() async {
    uid = await getCurrentUid();
    setState(() {});
  }

  Future<User?> getCurrentUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    return user;
  }

  getLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      setState(() {
        location = position;
      });
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      Placemark place = placemarks[0];
      setState(() {
        city = place.administrativeArea ?? "";
      });
    }).catchError((e) {
      setState(() {
        city = "Localisation";
      });
      // Gérer les erreurs ici
    });
  }

  // Stream<List<DocumentSnapshot<Object?>>>? getEvents(String val) {
  //   GeoFlutterFire geo = GeoFlutterFire();
  //   Stream<List<DocumentSnapshot<Object?>>>? stream1 =
  //       null; // Initialisation avec null
  //   if (val == null || val == 'All Events') {
  //     var collectionReference = FirebaseFirestore.instance
  //         .collection('events')
  //         .where('eventLive', isEqualTo: true);
  //     String field = 'position';
  //     if (geo != null && firePoint != null) {
  //       stream1 = geo.collection(collectionRef: collectionReference).within(
  //           center: firePoint!, radius: 50, field: field, strictMode: false);
  //     }
  //   } else {
  //     var collectionReference = FirebaseFirestore.instance
  //         .collection('events')
  //         .where('eventLive', isEqualTo: true)
  //         .where('eventCategory', isEqualTo: val);
  //     String field = 'position';
  //     if (geo != null && firePoint != null) {
  //       stream1 = geo.collection(collectionRef: collectionReference).within(
  //           center: firePoint!, radius: 50, field: field, strictMode: false);
  //     }
  //   }
  //   return stream1;
  // }

  @override
  void initState() {
    super.initState();
    // _controller = FancyDrawerController(
    //     vsync: this, duration: const Duration(milliseconds: 250))
    //   ..addListener(() {
    //     setState(() {}); // Must call setState
    //   });
    getUser();
    getLocation();
  }

  void dispose() {
    _controller.dispose(); // Dispose controller
    super.dispose();
  }

  void getData() async {
    if (uid != null) {
      userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      await userRef.get().then((snapshot) {
        if (mounted) {
          setState(() {
            name = snapshot['name'];
            email = snapshot['email'];
          });
        }
      });
    }
  }

  Widget build(BuildContext context) {
    // Future<User?> user = FirebaseAuth.instance.currentUser;
    double height = SizeConfig.getHeight(context);
    double width = SizeConfig.getWidth(context);
    return
        // FancyDrawerWrapper(
        //   controller: _controller,
        //   backgroundColor: AppColors.tertiary,
        //   drawerItems: <Widget>[
        //     Card(
        //       color: Colors.cyan,
        //       child: InkWell(
        //         onTap: () {
        //           //lien de l'application pour EventOs Partenaires
        //           // launch(
        //           //     'https://play.google.com/store/apps/details?id=');
        //         },
        //         child: Container(
        //           width: width * 0.5,
        //           child: const ListTile(
        //             title: Text(
        //               "Organiser des évènements",
        //               style: TextStyle(
        //                 fontSize: 18,
        //                 color: Colors.white,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             leading: Icon(Icons.event, color: Colors.black),
        //           ),
        //         ),
        //       ),
        //     ),
        //     Card(
        //       color: Colors.green,
        //       child: InkWell(
        //         onTap: () {
        //           Navigator.push(
        //               context, MaterialPageRoute(builder: (context) => Policy()));
        //         },
        //         child: Container(
        //           width: width * 0.5,
        //           child: const ListTile(
        //             title: Text(
        //               "Politiques de Confidentialité",
        //               style: TextStyle(
        //                 fontSize: 18,
        //                 color: Colors.white,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             leading: Icon(Icons.event, color: Colors.black),
        //           ),
        //         ),
        //       ),
        //     ),
        //     Card(
        //       color: Color.fromARGB(255, 179, 141, 4),
        //       child: InkWell(
        //         onTap: () {
        //           Navigator.push(
        //               context, MaterialPageRoute(builder: (context) => AboutUs()));
        //         },
        //         child: Container(
        //           width: width * 0.5,
        //           child: const ListTile(
        //             title: Text(
        //               "A Propos de l'Application",
        //               style: TextStyle(
        //                 fontSize: 18,
        //                 color: Colors.white,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             leading: Icon(Icons.event, color: Colors.black),
        //           ),
        //         ),
        //       ),
        //     ),
        //     Card(
        //       color: Colors.red,
        //       child: Container(
        //         width: width * 0.5,
        //         child: ListTile(
        //           onTap: () async {
        //             SharedPreferences prefs = await SharedPreferences.getInstance();
        //             prefs.clear();
        //             signOut();
        //             Navigator.pushAndRemoveUntil(
        //                 context,
        //                 MaterialPageRoute(builder: (context) => AskLogin()),
        //                 ModalRoute.withName('homepage'));
        //           },
        //           title: const Text(
        //             "Déconnexion",
        //             style: TextStyle(
        //               fontSize: 18,
        //               color: Colors.white,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //           leading: const Icon(Icons.album),
        //         ),
        //       ),
        //     ),
        //   ],

        //   child:

        Scaffold(
            bottomNavigationBar: BottomNavyBar(
              selectedIndex: _selectedIndex,
              showElevation: true,

              curve: Curves.ease, // use this to remove appBar's elevation
              onItemSelected: (index) {
                setState(() {
                  print(index);
                  _selectedIndex = index;
                  print(_selectedIndex);
                });
              },

              // onItemSelected: (index) => setState(() {
              //   _selectedIndex = index;
              // }),

              items: [
                BottomNavyBarItem(
                  icon: const Icon(Icons.event),
                  title: const Text('Présentiel'),
                  activeColor: Colors.red,
                ),
                BottomNavyBarItem(
                  icon: const Icon(Icons.laptop),
                  title: const Text('En ligne'),
                  activeColor: Colors.indigo,
                ),
                BottomNavyBarItem(
                    icon: const Icon(Icons.search),
                    title: const Text('Rechercher'),
                    activeColor: Colors.orange),
                BottomNavyBarItem(
                    icon: const Icon(Icons.local_movies_rounded),
                    title: const Text('J\'ai rejoins'),
                    activeColor: Colors.pink),
              ],
            ),
            resizeToAvoidBottomInset: false,
            drawer: GFDrawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  GFDrawerHeader(
                    currentAccountPicture: const GFAvatar(
                      radius: 80.0,
                      backgroundImage: NetworkImage(
                          "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg"),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(name),
                        Text(email),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.event, color: Colors.black),
                    title: const Text('Organiser des évènements'),
                    onTap: () {
                      //           //lien de l'application pour EventOs Partenaires

                      launchUrl(
                          Uri.https('play.google.com/store/apps/details?id='));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.policy, color: Colors.black),
                    title: const Text('Politiques de Confidentialité'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Policy()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people, color: Colors.black),
                    title: const Text('A Propos de l\'Application'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AboutUs()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.black),
                    title: const Text('Se Déconnecter'),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => AskLogin()),
                          ModalRoute.withName('homepage'));
                    },
                  ),
                ],
              ),
            ),
            body: _selectedIndex == 0
                ? CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        // leading: IconButton(
                        //   icon: const Icon(
                        //     Icons.menu,
                        //     color: Colors.black,
                        //   ),
                        //   onPressed: () {
                        //     _controller.toggle();
                        //   },
                        // ),
                        backgroundColor: Colors.white,
                        title: Container(
                          margin: EdgeInsets.only(
                              left: width / 50,
                              top: height / 15,
                              right: width / 50,
                              bottom: height / 30),
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                      child: Image.asset(
                                    'assets/logo.png',
                                    height: 50,
                                  )),
                                  IconButton(
                                    icon: Icon(Icons.tune,
                                        color: AppColors.primary, size: 25),
                                    color: AppColors.primary,
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),
                                              scrollable: true,
                                              backgroundColor:
                                                  AppColors.secondary,
                                              title: const Center(
                                                  child: Text(
                                                "Filtrer",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 30),
                                              )),
                                              content: Container(
                                                  height: height / 5,
                                                  child: Column(
                                                    children: [
                                                      DropdownButtonFormField(
                                                        items: categoryList,
                                                        value: selectedCat,
                                                        decoration:
                                                            InputDecoration(
                                                          labelStyle:
                                                              GoogleFonts.cabin(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 20,
                                                                  color: AppColors
                                                                      .primary),
                                                          labelText:
                                                              'Categorie d\'évènement',
                                                        ),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedCat = value;
                                                          });
                                                        },
                                                      ),
                                                      Expanded(
                                                        child: Center(
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  AppColors
                                                                      .primary,
                                                              backgroundColor:
                                                                  AppColors
                                                                      .tertiary, // Couleur du texte du bouton
                                                              elevation:
                                                                  10, // Élévation du bouton
                                                            ),
                                                            child: const Text(
                                                              "Appliquer les filtres",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                            );
                                          });
                                    },
                                    splashColor: Colors.purple,
                                  )
                                ],
                              ),
                              const SizedBox(height: 20)
                            ],
                          ),
                        ),
                        expandedHeight: 110,
                        pinned: true,
                        floating: true,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top + 70),
                            height: MediaQuery.of(context).padding.top + 110,
                            child: const Padding(
                              padding:
                                  EdgeInsets.only(right: 16.0, bottom: 10.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Evenements en Présentielle",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.redAccent),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      uid != null
                          ? StreamBuilder(
                              stream: selectedCat == null ||
                                      selectedCat == 'All Events'
                                  ? FirebaseFirestore.instance
                                      .collection('events')
                                      .where('eventLive', isEqualTo: true)
                                      .snapshots()
                                  : FirebaseFirestore.instance
                                      .collection('events')
                                      .where('eventLive', isEqualTo: true)
                                      .where('eventCategory',
                                          isEqualTo: selectedCat)
                                      .snapshots(),
                              builder: (BuildContext context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting &&
                                    snapshot.data == null) {
                                  return SliverFillRemaining(
                                      child: Center(
                                          child: SpinKitChasingDots(
                                              color: AppColors.secondary,
                                              size: 60)));
                                } else if (snapshot.hasData) {
                                  if (snapshot.data!.docs.isEmpty) {
                                    return SliverFillRemaining(
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Container(
                                              width: width,
                                              height: height / 2,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: SvgPicture.asset(
                                                      'assets/event.svg',
                                                      semanticsLabel:
                                                          'Event Illustration'),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: height / 20),
                                            const Text(
                                                "Pas d'évenement trouvé :(")
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return DetailPage(
                                                          0,
                                                          snapshot.data
                                                                  ?.docs[index]
                                                              as DocumentSnapshot<
                                                                  Object?>,
                                                          uid);
                                                    }));
                                                  },

                                                  child: GFCard(
                                                    showImage: true,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  12)),
                                                    ),
                                                    boxFit: BoxFit.cover,
                                                    image: Image.network(
                                                      '${snapshot.data?.docs[index]['eventBanner']}',
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.6,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    title: GFListTile(
                                                      title: Text(
                                                          '${snapshot.data?.docs[index]['eventName']}'),
                                                      subTitle: Text(
                                                        'Type: ${snapshot.data?.docs[index]['eventCategory']} \n ${DateFormat('dd-MM-yyyy AT hh:mm a').format(snapshot.data?.docs[index]['eventDateTime'].toDate())}',
                                                      ),
                                                      firstButtonTextStyle:
                                                          TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: AppColors
                                                                  .primary,
                                                              fontSize: 20),
                                                      secondButtonTextStyle:
                                                          TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                    content: Text(
                                                        "${snapshot.data?.docs[index]['eventDescription']}"),
                                                    buttonBar: GFButtonBar(
                                                      children: <Widget>[
                                                        GFButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                              return DetailPage(
                                                                  0,
                                                                  snapshot.data
                                                                              ?.docs[
                                                                          index]
                                                                      as DocumentSnapshot<
                                                                          Object?>,
                                                                  uid);
                                                            }));
                                                          },
                                                          text:
                                                              'Voir les détails',
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  // child: Card(
                                                  //   shape:
                                                  //       const RoundedRectangleBorder(
                                                  //     borderRadius:
                                                  //         BorderRadius.all(
                                                  //             Radius.circular(
                                                  //                 12)),
                                                  //   ),
                                                  //   elevation: 20,
                                                  //   child: ClipRRect(
                                                  //     borderRadius:
                                                  //         const BorderRadius
                                                  //             .all(
                                                  //             Radius.circular(
                                                  //                 12)),
                                                  //     child: CachedNetworkImage(
                                                  //       width: width * 0.9,
                                                  //       imageUrl: snapshot.data
                                                  //               ?.docs[index]
                                                  //           ['eventBanner'],
                                                  //       fit: BoxFit.fill,
                                                  //       placeholder: (context,
                                                  //               url) =>
                                                  //           SkeletonAnimation(
                                                  //         child: Container(
                                                  //           width: width * 0.9,
                                                  //           height:
                                                  //               height * 0.6,
                                                  //           decoration:
                                                  //               BoxDecoration(
                                                  //             color: Colors
                                                  //                 .purple[100],
                                                  //           ),
                                                  //         ),
                                                  //       ),
                                                  //       errorWidget: (context,
                                                  //               url, error) =>
                                                  //           const Icon(
                                                  //               Icons.error),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ),
                                              ),
                                              // Positioned(
                                              //   left: 10,
                                              //   top: 100,
                                              //   child: Container(
                                              //     width: width * 0.6,
                                              //     color: AppColors.secondary,
                                              //     child:
                                              //         Column(children: <Widget>[
                                              //       Padding(
                                              //         padding: const EdgeInsets
                                              //             .symmetric(
                                              //             horizontal: 8.0,
                                              //             vertical: 2),
                                              //         child: Center(
                                              //             child: Text(
                                              //           "${snapshot.data?.docs[index]['eventName']}",
                                              //           style:
                                              //               GoogleFonts.poppins(
                                              //             textStyle: TextStyle(
                                              //                 fontWeight:
                                              //                     FontWeight
                                              //                         .w800,
                                              //                 color: AppColors
                                              //                     .primary,
                                              //                 fontSize: 20),
                                              //           ),
                                              //           textAlign:
                                              //               TextAlign.center,
                                              //         )),
                                              //       ),
                                              //       Padding(
                                              //         padding:
                                              //             const EdgeInsets.all(
                                              //                 4),
                                              //         child: Center(
                                              //             child: Text(
                                              //           '${DateFormat('dd-MM-yyyy AT hh:mm a').format(snapshot.data?.docs[index]['eventDateTime'].toDate())}',
                                              //           style: const TextStyle(
                                              //               fontSize: 16,
                                              //               fontWeight:
                                              //                   FontWeight
                                              //                       .w700),
                                              //         )),
                                              //       ),
                                              //       Padding(
                                              //         padding:
                                              //             const EdgeInsets.all(
                                              //                 4),
                                              //         child: Center(
                                              //             child: Text(
                                              //           'Type: ${snapshot.data?.docs[index]['eventCategory']}',
                                              //           style: const TextStyle(
                                              //               fontSize: 16,
                                              //               fontWeight:
                                              //                   FontWeight
                                              //                       .w700),
                                              //         )),
                                              //       ),
                                              //       Padding(
                                              //         padding:
                                              //             const EdgeInsets.all(
                                              //                 6.0),
                                              //         child: Text(
                                              //           "${snapshot.data?.docs[index].get('position') ?? ''}\n${snapshot.data?.docs[index]['eventAddress']}",
                                              //           // Utilisez ?? '' pour fournir une chaîne vide si le champ 'position' est inexistant.
                                              //           style: const TextStyle(
                                              //             fontWeight:
                                              //                 FontWeight.w600,
                                              //             fontSize: 18,
                                              //           ),
                                              //         ),
                                              //       )
                                              //     ]),
                                              //   ),
                                              // )
                                            ],
                                          ),
                                        );
                                      },
                                      childCount: snapshot.data?.docs.length,
                                    ));
                                  }
                                } else {
                                  return SliverFillRemaining(
                                      child: Center(
                                          child: SpinKitChasingDots(
                                              color: AppColors.secondary,
                                              size: 60)));
                                }
                              })
                          : SliverFillRemaining(
                              child: Center(
                                  child: SpinKitChasingDots(
                                      color: AppColors.secondary, size: 60)))
                    ],
                  )
                // ? CustomScrollView(
                //     slivers: <Widget>[
                //       SliverAppBar(
                //         backgroundColor: Colors.white,
                //         leading: IconButton(
                //           icon: const Icon(
                //             Icons.menu,
                //             color: Colors.black,
                //           ),
                //           onPressed: () {
                //             _controller.toggle();
                //           },
                //         ),
                //         title: Container(
                //           margin: EdgeInsets.only(
                //               left: width / 50,
                //               top: height / 15,
                //               right: width / 50,
                //               bottom: height / 30),
                //           width: width,
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: <Widget>[
                //               Row(
                //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Expanded(
                //                       child: Image.asset(
                //                     'assets/logo.png',
                //                     height: 50,
                //                   )),
                //                   IconButton(
                //                     icon: Icon(Icons.tune,
                //                         color: AppColors.primary, size: 25),
                //                     color: AppColors.primary,
                //                     onPressed: () {
                //                       showDialog(
                //                           context: context,
                //                           builder: (context) {
                //                             return AlertDialog(
                //                               shape: const RoundedRectangleBorder(
                //                                   borderRadius: BorderRadius.all(
                //                                       Radius.circular(10.0))),
                //                               scrollable: true,
                //                               backgroundColor:
                //                                   AppColors.secondary,
                //                               title: const Center(
                //                                   child: Text(
                //                                 "Filtrer",
                //                                 style: TextStyle(
                //                                     color: Colors.white,
                //                                     fontWeight: FontWeight.w700,
                //                                     fontSize: 30),
                //                               )),
                //                               content: Container(
                //                                   height: height / 5,
                //                                   child: Column(
                //                                     children: [
                //                                       DropdownButtonFormField(
                //                                         items: categoryList,
                //                                         value: selectedCat,
                //                                         decoration:
                //                                             InputDecoration(
                //                                           labelStyle:
                //                                               GoogleFonts.cabin(
                //                                                   fontWeight:
                //                                                       FontWeight
                //                                                           .w600,
                //                                                   fontSize: 20,
                //                                                   color: AppColors
                //                                                       .primary),
                //                                           labelText:
                //                                               'Categorie d\'évènement',
                //                                         ),
                //                                         onChanged: (value) {
                //                                           setState(() {
                //                                             selectedCat = value;
                //                                           });
                //                                         },
                //                                       ),
                //                                       Expanded(
                //                                         child: Center(
                //                                             child: ElevatedButton(
                //                                           onPressed: () {
                //                                             Navigator.pop(
                //                                                 context);
                //                                           },
                //                                           style: ElevatedButton
                //                                               .styleFrom(
                //                                             backgroundColor: AppColors
                //                                                 .primary, // Couleur du bouton
                //                                             elevation:
                //                                                 10, // Élévation du bouton
                //                                           ),
                //                                           child: Text(
                //                                             "Appliquer les filtres",
                //                                             style: TextStyle(
                //                                               fontWeight:
                //                                                   FontWeight.w600,
                //                                               fontSize: 20,
                //                                               color: AppColors
                //                                                   .tertiary,
                //                                             ),
                //                                           ),
                //                                         )),
                //                                       )
                //                                     ],
                //                                   )),
                //                             );
                //                           });
                //                     },
                //                     splashColor: Colors.purple,
                //                   )
                //                 ],
                //               ),
                //               const SizedBox(height: 20)
                //             ],
                //           ),
                //         ),
                //         expandedHeight: 110,
                //         pinned: true,
                //         floating: true,
                //         flexibleSpace: FlexibleSpaceBar(
                //           background: Container(
                //             color: Colors.white,
                //             padding: EdgeInsets.only(
                //                 top: MediaQuery.of(context).padding.top + 70),
                //             height: MediaQuery.of(context).padding.top + 110,
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: <Widget>[
                //                 Padding(
                //                     padding: EdgeInsets.only(
                //                         left: width / 18, bottom: 10),
                //                     child: Align(
                //                       child: GestureDetector(
                //                           onTap: () async {
                //                             Navigator.push(
                //                               context,
                //                               MaterialPageRoute(
                //                                 builder: (context) => PlacePicker(
                //                                     apiKey: Platform.isAndroid
                //                                         ? 'AIzaSyDMQXRp4mmMw9kx4E_YOVChFyInWdgsKXU' // Votre clé API pour Android
                //                                         : "AIzaSyDYKfjtKoVpCTlwiT29ioqflI62gzclKOQ", // Votre clé API pour iOS
                //                                     useCurrentLocation: true,
                //                                     selectInitialPosition: true,
                //                                     onPlacePicked: (result) {
                //                                       setState(() {
                //                                         city =
                //                                             "${result.formattedAddress}";
                //                                         firePoint = geo.point(
                //                                           latitude: result
                //                                               .geometry!
                //                                               .location
                //                                               .lat,
                //                                           longitude: result
                //                                               .geometry!
                //                                               .location
                //                                               .lng,
                //                                         );
                //                                       });
                //                                       Navigator.of(context).pop();
                //                                     },
                //                                     initialPosition: HomePage
                //                                         .kInitialPosition),
                //                               ),
                //                             );
                //                           },
                //                           child: Text(
                //                             city == null
                //                                 ? 'En attente de localisation'
                //                                 : city,
                //                             style: const TextStyle(
                //                                 fontWeight: FontWeight.w500,
                //                                 fontSize: 18,
                //                                 color: Colors.redAccent,
                //                                 fontStyle: FontStyle.italic,
                //                                 decoration:
                //                                     TextDecoration.underline),
                //                           )),
                //                     )),
                //                 const Padding(
                //                   padding:
                //                       EdgeInsets.only(right: 16.0, bottom: 10.0),
                //                   child: Align(
                //                     alignment: Alignment.centerRight,
                //                     child: Text(
                //                       "Présentiel",
                //                       style: TextStyle(
                //                           fontWeight: FontWeight.w500,
                //                           fontSize: 16,
                //                           color: Colors.redAccent),
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //       uid != null
                //           ? StreamBuilder(
                //               stream: getEvents(selectedCat),
                //               builder: (BuildContext context1, snapshot) {
                //                 if (snapshot.connectionState ==
                //                         ConnectionState.waiting &&
                //                     snapshot.data == null) {
                //                   return SliverFillRemaining(
                //                       child: Center(
                //                           child: SpinKitChasingDots(
                //                               color: AppColors.secondary,
                //                               size: 60)));
                //                 } else if (snapshot.hasData) {
                //                   if (snapshot.data!.length == 0) {
                //                     return SliverFillRemaining(
                //                       child: Center(
                //                         child: Column(
                //                           children: [
                //                             Container(
                //                               width: width,
                //                               height: height / 2,
                //                               child: Center(
                //                                 child: Padding(
                //                                   padding:
                //                                       const EdgeInsets.all(16.0),
                //                                   child: SvgPicture.asset(
                //                                       'assets/event.svg',
                //                                       semanticsLabel:
                //                                           'Event Illustration'),
                //                                 ),
                //                               ),
                //                             ),
                //                             SizedBox(height: height / 20),
                //                             const Text(
                //                                 "Pas d'évenements près de chez vous :(")
                //                           ],
                //                         ),
                //                       ),
                //                     );
                //                   } else {
                //                     return SliverList(
                //                         delegate: SliverChildBuilderDelegate(
                //                       (context, index) {
                //                         return Padding(
                //                           padding:
                //                               const EdgeInsets.only(bottom: 20),
                //                           child: Stack(
                //                             children: [
                //                               Center(
                //                                 child: GestureDetector(
                //                                   onTap: () {
                //                                     Navigator.push(context,
                //                                         MaterialPageRoute(
                //                                             builder: (context) {
                //                                       return DetailPage(
                //                                           0,
                //                                           snapshot.data![index],
                //                                           uid);
                //                                     }));
                //                                   },
                //                                   child: Card(
                //                                     shape:
                //                                         const RoundedRectangleBorder(
                //                                       borderRadius:
                //                                           BorderRadius.all(
                //                                               Radius.circular(
                //                                                   12)),
                //                                     ),
                //                                     elevation: 20,
                //                                     child: ClipRRect(
                //                                       borderRadius:
                //                                           const BorderRadius.all(
                //                                               Radius.circular(
                //                                                   12)),
                //                                       child: CachedNetworkImage(
                //                                         width: width * 0.9,
                //                                         imageUrl:
                //                                             snapshot.data![index]
                //                                                 ['eventBanner'],
                //                                         fit: BoxFit.fill,
                //                                         placeholder:
                //                                             (context, url) =>
                //                                                 SkeletonAnimation(
                //                                           child: Container(
                //                                             width: width * 0.9,
                //                                             height: height * 0.6,
                //                                             decoration:
                //                                                 BoxDecoration(
                //                                               color: Colors
                //                                                   .purple[100],
                //                                             ),
                //                                           ),
                //                                         ),
                //                                         errorWidget: (context,
                //                                                 url, error) =>
                //                                             const Icon(
                //                                                 Icons.error),
                //                                       ),
                //                                     ),
                //                                   ),
                //                                 ),
                //                               ),
                //                               Positioned(
                //                                 left: 10,
                //                                 top: 100,
                //                                 child: Container(
                //                                   width: width * 0.6,
                //                                   color: AppColors.secondary,
                //                                   child:
                //                                       Column(children: <Widget>[
                //                                     Padding(
                //                                       padding: const EdgeInsets
                //                                           .symmetric(
                //                                           horizontal: 8.0,
                //                                           vertical: 2),
                //                                       child: Center(
                //                                           child: Text(
                //                                         "${snapshot.data![index]['eventName']}",
                //                                         style:
                //                                             GoogleFonts.poppins(
                //                                           textStyle: TextStyle(
                //                                               fontWeight:
                //                                                   FontWeight.w800,
                //                                               color: AppColors
                //                                                   .primary,
                //                                               fontSize: 20),
                //                                         ),
                //                                         textAlign:
                //                                             TextAlign.center,
                //                                       )),
                //                                     ),
                //                                     Padding(
                //                                       padding:
                //                                           const EdgeInsets.all(4),
                //                                       child: Center(
                //                                           child: Text(
                //                                         DateFormat(
                //                                                 'dd-MM-yyyy AT hh:mm a')
                //                                             .format(snapshot
                //                                                 .data![index][
                //                                                     'eventDateTime']
                //                                                 .toDate()),
                //                                         style: const TextStyle(
                //                                             fontSize: 16,
                //                                             fontWeight:
                //                                                 FontWeight.w700),
                //                                       )),
                //                                     ),
                //                                     Padding(
                //                                       padding:
                //                                           const EdgeInsets.all(4),
                //                                       child: Center(
                //                                           child: Text(
                //                                         'Type: ${snapshot.data![index]['eventCategory']}',
                //                                         style: const TextStyle(
                //                                             fontSize: 16,
                //                                             fontWeight:
                //                                                 FontWeight.w700),
                //                                       )),
                //                                     ),
                //                                     Padding(
                //                                       padding:
                //                                           const EdgeInsets.all(
                //                                               6.0),
                //                                       child: Text(
                //                                           "${snapshot.data![index]['eventAddress']}",
                //                                           textAlign:
                //                                               TextAlign.center,
                //                                           style: GoogleFonts.poppins(
                //                                               textStyle:
                //                                                   const TextStyle(
                //                                                       fontWeight:
                //                                                           FontWeight
                //                                                               .w600,
                //                                                       fontSize:
                //                                                           14))),
                //                                     )
                //                                   ]),
                //                                 ),
                //                               )
                //                             ],
                //                           ),
                //                         );
                //                       },
                //                       childCount: snapshot.data!.length,
                //                     ));
                //                   }
                //                 } else
                //                   return SliverFillRemaining(
                //                       child: Center(
                //                           child: SpinKitChasingDots(
                //                               color: AppColors.secondary,
                //                               size: 60)));
                //               })
                //           : SliverFillRemaining(
                //               child: Center(
                //                   child: SpinKitChasingDots(
                //                       color: AppColors.secondary, size: 60)))
                //     ],
                //   )

                : _selectedIndex == 1
                    ? CustomScrollView(
                        slivers: <Widget>[
                          SliverAppBar(
                            // leading: IconButton(
                            //   icon: const Icon(
                            //     Icons.menu,
                            //     color: Colors.black,
                            //   ),
                            //   onPressed: () {
                            //     _controller.toggle();
                            //   },
                            // ),
                            backgroundColor: Colors.white,
                            title: Container(
                              margin: EdgeInsets.only(
                                  left: width / 50,
                                  top: height / 15,
                                  right: width / 50,
                                  bottom: height / 30),
                              width: width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                          child: Image.asset(
                                        'assets/logo.png',
                                        height: 50,
                                      )),
                                      IconButton(
                                        icon: Icon(Icons.tune,
                                            color: AppColors.primary, size: 25),
                                        color: AppColors.primary,
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.0))),
                                                  scrollable: true,
                                                  backgroundColor:
                                                      AppColors.secondary,
                                                  title: const Center(
                                                      child: Text(
                                                    "Filtrer",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 30),
                                                  )),
                                                  content: Container(
                                                      height: height / 5,
                                                      child: Column(
                                                        children: [
                                                          DropdownButtonFormField(
                                                            items: categoryList,
                                                            value: selectedCat,
                                                            decoration:
                                                                InputDecoration(
                                                              labelStyle: GoogleFonts.cabin(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 20,
                                                                  color: AppColors
                                                                      .primary),
                                                              labelText:
                                                                  'Categorie d\'évènement',
                                                            ),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selectedCat =
                                                                    value;
                                                              });
                                                            },
                                                          ),
                                                          Expanded(
                                                            child: Center(
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  foregroundColor:
                                                                      AppColors
                                                                          .primary,
                                                                  backgroundColor:
                                                                      AppColors
                                                                          .tertiary, // Couleur du texte du bouton
                                                                  elevation:
                                                                      10, // Élévation du bouton
                                                                ),
                                                                child:
                                                                    const Text(
                                                                  "Appliquer les filtres",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                );
                                              });
                                        },
                                        splashColor: Colors.purple,
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20)
                                ],
                              ),
                            ),
                            expandedHeight: 110,
                            pinned: true,
                            floating: true,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Container(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).padding.top +
                                        70),
                                height:
                                    MediaQuery.of(context).padding.top + 110,
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                      right: 16.0, bottom: 10.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Evenements en ligne",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.blueAccent),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          uid != null
                              ? StreamBuilder(
                                  stream: selectedCat == null ||
                                          selectedCat == 'All Events'
                                      ? FirebaseFirestore.instance
                                          .collection('OnlineEvents')
                                          .where('eventLive', isEqualTo: true)
                                          .snapshots()
                                      : FirebaseFirestore.instance
                                          .collection('OnlineEvents')
                                          .where('eventLive', isEqualTo: true)
                                          .where('eventCategory',
                                              isEqualTo: selectedCat)
                                          .snapshots(),
                                  builder: (BuildContext context1, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.waiting &&
                                        snapshot.data == null) {
                                      return SliverFillRemaining(
                                          child: Center(
                                              child: SpinKitChasingDots(
                                                  color: AppColors.secondary,
                                                  size: 60)));
                                    } else if (snapshot.hasData) {
                                      if (snapshot.data!.docs.isEmpty) {
                                        return SliverFillRemaining(
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: width,
                                                  height: height / 2,
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: SvgPicture.asset(
                                                          'assets/event.svg',
                                                          semanticsLabel:
                                                              'Event Illustration'),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: height / 20),
                                                const Text(
                                                    "Pas d'évenement trouvé :(")
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        return SliverList(
                                            delegate:
                                                SliverChildBuilderDelegate(
                                          (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 20),
                                              child: Stack(
                                                children: [
                                                  Center(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                          return DetailPage(
                                                              1,
                                                              snapshot.data
                                                                          ?.docs[
                                                                      index]
                                                                  as DocumentSnapshot<
                                                                      Object?>,
                                                              uid);
                                                        }));
                                                      },

                                                      child: GFCard(
                                                        showImage: true,
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          12)),
                                                        ),
                                                        boxFit: BoxFit.cover,
                                                        image: Image.network(
                                                          '${snapshot.data?.docs[index]['eventBanner']}',
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.6,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        title: GFListTile(
                                                          title: Text(
                                                              '${snapshot.data?.docs[index]['eventName']}'),
                                                          subTitle: Text(
                                                            'Type: ${snapshot.data?.docs[index]['eventCategory']} \n ${DateFormat('dd-MM-yyyy AT hh:mm a').format(snapshot.data?.docs[index]['eventDateTime'].toDate())}',
                                                          ),
                                                          firstButtonTextStyle:
                                                              TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  color: AppColors
                                                                      .primary,
                                                                  fontSize: 20),
                                                          secondButtonTextStyle:
                                                              TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        ),
                                                        content: Text(
                                                            "${snapshot.data?.docs[index]['eventDescription']}"),
                                                        buttonBar: GFButtonBar(
                                                          children: <Widget>[
                                                            GFButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) {
                                                                  return DetailPage(
                                                                      0,
                                                                      snapshot.data
                                                                              ?.docs[index]
                                                                          as DocumentSnapshot<
                                                                              Object?>,
                                                                      uid);
                                                                }));
                                                              },
                                                              text:
                                                                  'Voir les détails',
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // child: Card(
                                                      //   shape:
                                                      //       const RoundedRectangleBorder(
                                                      //     borderRadius:
                                                      //         BorderRadius.all(
                                                      //             Radius
                                                      //                 .circular(
                                                      //                     12)),
                                                      //   ),
                                                      //   elevation: 20,
                                                      //   child: ClipRRect(
                                                      //     borderRadius:
                                                      //         const BorderRadius
                                                      //             .all(Radius
                                                      //                 .circular(
                                                      //                     12)),
                                                      //     child:
                                                      //         CachedNetworkImage(
                                                      //       width: width * 0.9,
                                                      //       imageUrl: snapshot
                                                      //               .data
                                                      //               ?.docs[index]
                                                      //           ['eventBanner'],
                                                      //       fit: BoxFit.fill,
                                                      //       placeholder: (context,
                                                      //               url) =>
                                                      //           SkeletonAnimation(
                                                      //         child: Container(
                                                      //           width:
                                                      //               width * 0.9,
                                                      //           height: height *
                                                      //               0.6,
                                                      //           decoration:
                                                      //               BoxDecoration(
                                                      //             color: Colors
                                                      //                     .purple[
                                                      //                 100],
                                                      //           ),
                                                      //         ),
                                                      //       ),
                                                      //       errorWidget: (context,
                                                      //               url,
                                                      //               error) =>
                                                      //           const Icon(Icons
                                                      //               .error),
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                    ),
                                                  ),
                                                  // Positioned(
                                                  //   left: 10,
                                                  //   top: 100,
                                                  //   child: Container(
                                                  //     width: width * 0.6,
                                                  //     color:
                                                  //         AppColors.secondary,
                                                  //     child: Column(
                                                  //         children: <Widget>[
                                                  //           Padding(
                                                  //             padding:
                                                  //                 const EdgeInsets
                                                  //                     .symmetric(
                                                  //                     horizontal:
                                                  //                         8.0,
                                                  //                     vertical:
                                                  //                         2),
                                                  //             child: Center(
                                                  //                 child: Text(
                                                  //               "${snapshot.data?.docs[index]['eventName']}",
                                                  //               style:
                                                  //                   GoogleFonts
                                                  //                       .poppins(
                                                  //                 textStyle: TextStyle(
                                                  //                     fontWeight:
                                                  //                         FontWeight
                                                  //                             .w800,
                                                  //                     color: AppColors
                                                  //                         .primary,
                                                  //                     fontSize:
                                                  //                         20),
                                                  //               ),
                                                  //               textAlign:
                                                  //                   TextAlign
                                                  //                       .center,
                                                  //             )),
                                                  //           ),
                                                  //           Padding(
                                                  //             padding:
                                                  //                 const EdgeInsets
                                                  //                     .all(4),
                                                  //             child: Center(
                                                  //                 child: Text(
                                                  //               '${DateFormat('dd-MM-yyyy AT hh:mm a').format(snapshot.data?.docs[index]['eventDateTime'].toDate())}',
                                                  //               style: const TextStyle(
                                                  //                   fontSize:
                                                  //                       16,
                                                  //                   fontWeight:
                                                  //                       FontWeight
                                                  //                           .w700),
                                                  //             )),
                                                  //           ),
                                                  //           Padding(
                                                  //             padding:
                                                  //                 const EdgeInsets
                                                  //                     .all(4),
                                                  //             child: Center(
                                                  //                 child: Text(
                                                  //               'Type: ${snapshot.data?.docs[index]['eventCategory']}',
                                                  //               style: const TextStyle(
                                                  //                   fontSize:
                                                  //                       16,
                                                  //                   fontWeight:
                                                  //                       FontWeight
                                                  //                           .w700),
                                                  //             )),
                                                  //           ),
                                                  //         ]),
                                                  //   ),
                                                  // )
                                                ],
                                              ),
                                            );
                                          },
                                          childCount:
                                              snapshot.data?.docs.length,
                                        ));
                                      }
                                    } else {
                                      return SliverFillRemaining(
                                          child: Center(
                                              child: SpinKitChasingDots(
                                                  color: AppColors.secondary,
                                                  size: 60)));
                                    }
                                  })
                              : SliverFillRemaining(
                                  child: Center(
                                      child: SpinKitChasingDots(
                                          color: AppColors.secondary,
                                          size: 60)))
                        ],
                      )
                    : _selectedIndex == 2
                        ? SearchPage()
                        : JoinedEvents(uid));
    // );
  }
}
