// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/Models/category.dart';
import 'package:flutter_project/Widgets/category_widget.dart';
import 'package:flutter_project/pages/AboutUs.dart';
import 'package:flutter_project/pages/EventDetails.dart';
import 'package:flutter_project/pages/JoinedEvents.dart';
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

import 'package:getwidget/getwidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // Déclaration des variables nécessaires
  late int _selectedIndex = 0; //0 pour even en presentiel et 1 pour en ligne

  String selectedCat =
      "All Events"; //La catégorie sélectionnée. Par défaut Tous les évènements

  Widget build(BuildContext context) {
    User? user =
        FirebaseAuth.instance.currentUser; //On récupère l'utilisateur actuel
    double height = SizeConfig.getHeight(context);
    double width = SizeConfig.getWidth(context);
    const String photUrl =
        "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg"; //Photo de profil par défaut
    String photoURL = user!.photoURL ?? photUrl; // Photo de  profil

    return Scaffold(
        bottomNavigationBar: BottomNavyBar(
          // Barre de navigation inférieure

          selectedIndex: _selectedIndex,
          showElevation: true,

          curve: Curves.ease, // use this to remove appBar's elevation
          onItemSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },

          items: [
            // Les éléments de la barre de navigation inférieure

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
                title: const Text('Mes PASS'),
                activeColor: Colors.pink),
          ],
        ),
        resizeToAvoidBottomInset: false,
        drawer: GFDrawer(
          // Tiroir latéral; GFDrawer est issu de la bibliothèque de widget getwidget
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Les éléments du tiroir latéral
              GFDrawerHeader(
                //En tete avec avatar et nom
                currentAccountPicture: GFAvatar(
                  radius: 80.0,
                  backgroundImage: NetworkImage(photoURL),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(user.displayName ?? ""),
                    Text(user.email ?? ""),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.event, color: Colors.black),
                title: const Text('Organiser des évènements'),
                onTap: () {
                  //lien de l'application pour EventOs Partenaires

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
            ? //Si =0, alors => Page Evenements en ligne
            CustomScrollView(
                slivers: <Widget>[
                  // Les slivers pour l'affichage de la page
                  SliverAppBar(
                    //Barre de Navigation
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                  child: Image.asset(
                                'assets/logo.png',
                                height: 50,
                              )),
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
                          padding: EdgeInsets.only(right: 16.0, bottom: 10.0),
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

                  SliverList(
                    //Caroussel des catégories
                    delegate: SliverChildListDelegate([
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32.0),
                                  child: Text(
                                    "Quoi de neuf",
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        for (final category in categories)
                                          GestureDetector(
                                              child: CategoryWidget(
                                            category: category,
                                            isSelected:
                                                category.value == selectedCat,
                                            onCategoryTap: () {
                                              setState(() {
                                                selectedCat = category.value!;
                                              });
                                            },
                                          ))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),

                  user.uid != null
                      ? //Si l'utilisateur est connecté
                      StreamBuilder(
                          //StreamBuilder permet de réagir aux changements d'un flux de données en temps réel(BDD, API)
                          stream: selectedCat == null ||
                                  selectedCat == 'All Events'
                              ? //Si aucune catégorie est sélectionnée
                              FirebaseFirestore.instance
                                  .collection('events')
                                  .where('eventLive', isEqualTo: true)
                                  .where('eventDateTime',
                                      isGreaterThan: DateTime.now())
                                  .snapshots() //On récupère les évènements futur de toutes les catégories
                              : //Si une catégorie est sélectionnée
                              FirebaseFirestore.instance
                                  .collection('events')
                                  .where('eventLive', isEqualTo: true)
                                  .where('eventCategory',
                                      isEqualTo: selectedCat)
                                  .where('eventDateTime',
                                      isGreaterThan: DateTime
                                          .now()) //On récupère les évènements futur de la catégorie
                                  .snapshots(),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                snapshot.data == null) {
                              // Afficher un indicateur de chargement si la connexion est en cours et qu'il n'y a pas de données
                              return SliverFillRemaining(
                                  child: Center(
                                      child: SpinKitChasingDots(
                                          color: AppColors.secondary,
                                          size: 60)));
                            } else if (snapshot.hasData) {
                              if (snapshot.data!.docs
                                  .isEmpty) // Afficher un message si aucun événement n'est trouvé
                              {
                                return SliverFillRemaining(
                                  child: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: width,
                                          height: height / 3,
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: SvgPicture.asset(
                                                  'assets/event.svg',
                                                  semanticsLabel:
                                                      'Event Illustration'),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: height / 20),
                                        const Text("Pas d'évenement trouvé :(")
                                      ],
                                    ),
                                  ),
                                );
                              } else // Affiche une liste d'événements si des données sont disponibles
                              {
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
                                                      snapshot.data?.docs[index]
                                                          as DocumentSnapshot<
                                                              Object?>,
                                                      user.uid);
                                                }));
                                              },
                                              child: GFCard(
                                                //Template GFCard du package Getwidget
                                                showImage: true,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(12)),
                                                ),
                                                boxFit: BoxFit.cover,
                                                image: Image.network(
                                                  '${snapshot.data?.docs[index]['eventBanner']}',
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.6,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    } else {
                                                      return Center(
                                                          child: GFProgressBar(
                                                        percentage: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : 100,
                                                        lineHeight: 20,
                                                        backgroundColor:
                                                            Colors.black26,
                                                        progressBarColor:
                                                            GFColors.SUCCESS,
                                                      ));
                                                    }
                                                  },
                                                ),
                                                title: GFListTile(
                                                  title: Text(
                                                    '${snapshot.data?.docs[index]['eventName']}',
                                                    style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color: AppColors
                                                                .primary,
                                                            fontSize: 20)),
                                                  ),
                                                  subTitle: Text(
                                                    'Catégorie: ${snapshot.data?.docs[index]['eventCategory']} \n ${DateFormat('EEEE-dd-MM-yyyy à hh:mm').format(snapshot.data?.docs[index]['eventDateTime'].toDate())}',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                                content: Text(
                                                    "${snapshot.data?.docs[index]['eventDescription']}"),
                                                buttonBar: GFButtonBar(
                                                  children: <Widget>[
                                                    GFButton(
                                                      onPressed: () {
                                                        Navigator.push(context,
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
                                                              user.uid);
                                                        }));
                                                      },
                                                      text: 'Voir les détails',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  childCount: snapshot.data?.docs.length,
                                ));
                              }
                            } else // Affiche un indicateur de chargement si les données ne sont pas encore disponibles

                            {
                              return SliverFillRemaining(
                                  child: Center(
                                      child: SpinKitChasingDots(
                                          color: AppColors.secondary,
                                          size: 60)));
                            }
                          })
                      : // Affiche un indicateur de chargement si l'utilisateur n'est pas connecté
                      SliverFillRemaining(
                          child: Center(
                              child: SpinKitChasingDots(
                                  color: AppColors.secondary, size: 60)))
                ],
              )
            : _selectedIndex == 1
                ? //Sinon si =1, alors => Page Evenements en ligne
                CustomScrollView(
                    slivers: <Widget>[
                      // Les slivers pour l'affichage de la page
                      SliverAppBar(
                        //Barre de Navigation
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

                      SliverList(
                        //Caroussel des catégories
                        delegate: SliverChildListDelegate([
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32.0),
                                      child: Text(
                                        "Quoi de neuf",
                                        style: TextStyle(
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.secondary,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 24.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            for (final category in categories)
                                              GestureDetector(
                                                  child: CategoryWidget(
                                                category: category,
                                                isSelected: category.value ==
                                                    selectedCat,
                                                onCategoryTap: () {
                                                  setState(() {
                                                    selectedCat =
                                                        category.value!;
                                                    print(selectedCat);
                                                  });
                                                },
                                              ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                      user.uid != null
                          ? //Si l'utilisateur est connecté
                          StreamBuilder(
                              stream: selectedCat == null ||
                                      selectedCat == 'All Events'
                                  ? FirebaseFirestore.instance
                                      .collection('OnlineEvents')
                                      .where('eventLive', isEqualTo: true)
                                      .where('eventDateTime',
                                          isGreaterThan: DateTime
                                              .now()) //Cete condition pour juste les évènements futur
                                      .snapshots()
                                  : FirebaseFirestore.instance
                                      .collection('OnlineEvents')
                                      .where('eventLive', isEqualTo: true)
                                      .where('eventCategory',
                                          isEqualTo: selectedCat)
                                      .where('eventDateTime',
                                          isGreaterThan: DateTime
                                              .now()) //Cete condition pour juste les évènements futur
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
                                              height: height / 3,
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
                                                          1,
                                                          snapshot.data
                                                                  ?.docs[index]
                                                              as DocumentSnapshot<
                                                                  Object?>,
                                                          user.uid);
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
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        } else {
                                                          return Center(
                                                              child:
                                                                  GFProgressBar(
                                                            percentage: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    loadingProgress
                                                                        .expectedTotalBytes!
                                                                : 100,
                                                            lineHeight: 20,
                                                            backgroundColor:
                                                                Colors.black26,
                                                            progressBarColor:
                                                                GFColors
                                                                    .SUCCESS,
                                                          ));
                                                        }
                                                      },
                                                    ),
                                                    title: GFListTile(
                                                      title: Text(
                                                        '${snapshot.data?.docs[index]['eventName']}',
                                                        style: GoogleFonts.poppins(
                                                            textStyle: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: AppColors
                                                                    .primary,
                                                                fontSize: 20)),
                                                      ),
                                                      subTitle: Text(
                                                        'Catégorie: ${snapshot.data?.docs[index]['eventCategory']} \n ${DateFormat('EEEE-dd-MM-yyyy à hh:mm ').format(snapshot.data?.docs[index]['eventDateTime'].toDate())}',
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
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
                                                                  user.uid);
                                                            }));
                                                          },
                                                          text:
                                                              'Voir les détails',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
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
                              //Utilisateur pas connecté
                              child: Center(
                                  child: SpinKitChasingDots(
                                      color: AppColors.secondary, size: 60)))
                    ],
                  )
                : _selectedIndex == 2
                    ? //Sinon si =2, alors => Page de recherche
                    SearchPage()
                    : //Sinon
                    //Page des évènements rejoins

                    JoinedEvents(user.uid));
  }
}
