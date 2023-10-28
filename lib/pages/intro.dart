import 'package:intro_slider/intro_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/pages/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreenState extends StatefulWidget {
  @override
  _IntroScreenStateState createState() => _IntroScreenStateState();
}

class _IntroScreenStateState extends State<IntroScreenState> {
  List<ContentConfig> listContentConfig = [];

  @override
  void initState() {
    super.initState();
    listContentConfig.add(
      const ContentConfig(
        title: "Événements à portée de main",
        description:
            "Obtenez tous les événements à venir basés sur votre emplacement avec tous les détails comme le lieu, la date, l'heure, etc.",
        pathImage: "assets/intro1.png",
        backgroundColor: Color(0xfff5a623),
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        title: "Événements en ligne",
        description: "Profitez des événements en ligne",
        pathImage: "assets/intro4.png",
        backgroundColor: Color(0xff203152),
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        title: "Achetez des passes",
        description:
            "Achetez facilement des passes/billets pour l'événement, entrée fluide en scannant le code QR sur la passe",
        pathImage: "assets/intro3.png",
        backgroundColor: Color(0xff9932CC),
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        title: "Notification/Rappels",
        description:
            "Ne manquez jamais une annonce ou un rappel lié à l'événement auquel vous  participez",
        pathImage: "assets/intro2.png",
        backgroundColor: Color(0xff203152),
      ),
    );
  }

  void onDonePress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('first', false);
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      key: UniqueKey(),
      listContentConfig: listContentConfig,
      onDonePress: onDonePress,
    );
  }
}
