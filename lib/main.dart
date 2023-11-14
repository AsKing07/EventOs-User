import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_project/config/config.dart';
import 'package:flutter_project/pages/NotConnectedScreen.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'pages/HomePage.dart';
import 'pages/loginui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:connectivity_checker/connectivity_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); //Initialiser Firebase

  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  ); //Contribue à l'initialisation de Firebase AppCheck

  // AndroidGoogleMapsFlutter.useAndroidViewSurface = true;

  //On vérifie dans SharedPreference si l'utilisateur est déjà connecté.
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? login = prefs.getBool('login');

  await FlutterConfig
      .loadEnvVariables(); //Charge les variables d'environnement si il y en a

  final connected = await checkInternetConnection(); //check internet connection

  if (connected) {
    //Si il y a acces à internet
    runApp(
      // Si l'utilisateur est connecté à l'application, affichez l'application MyApp sinon MyApp1
      login == null
          ? MyApp1()
          : login
              ? MyApp()
              : MyApp1(),
    );
  } else {
    runApp(
      // Si il n'y a pas de connexion Internet, affichez l'application MyApp2
      MyApp2(),
    );
  }
}

Future<bool> checkInternetConnection() async {
  final isConnected = await ConnectivityWrapper.instance.isConnected;
  if (isConnected) {
    return true;
  } else {
    // Pas de connexion Internet, vous pouvez afficher un écran d'erreur ou un message à l'utilisateur.
    return false;
  }
}

//MyApp redirige l'user vers la page d'accueil;
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventos',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        hintColor: AppColors.secondary,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
      routes: {
        'login': (context) => const AskLogin(),
        'homepage': (context) => const HomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

//MyApp1 vers la page de connection
class MyApp1 extends StatelessWidget {
  const MyApp1({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventos',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        hintColor: AppColors.secondary,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AskLogin(),
      routes: {
        'login': (context) => const AskLogin(),
        'homepage': (context) => const HomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

//MyApp2 vers la page d'erreur d'acces à internet
class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventos',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        hintColor: AppColors.secondary,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NotConnectedScreen(),
      routes: {
        'login': (context) => const AskLogin(),
        'homepage': (context) => const HomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}



/*
Dans ce code : 
 
1- La fonction  main  est la fonction de démarrage de l'application. 
  Elle initialise Firebase, Firebase App Check, et les dépendances nécessaires. 
  Elle vérifie la connexion Internet, puis lance l'application en fonction de 
  l'état de connexion et de la connexion de l'utilisateur. 
 
2- La fonction  checkInternetConnection  vérifie si l'appareil est connecté à 
  Internet en utilisant le package  connectivity_checker . 
  Elle renvoie  true  si l'appareil est connecté, sinon elle renvoie  false . 
 
3- Les classes  MyApp ,  MyApp1 , et  MyApp2  sont des widgets racine de l'application 
  qui définissent le thème, la configuration, et les routes de navigation en fonction 
  de l'état de connexion et de la connexion de l'utilisateur. 
 
4- Les widgets  HomePage ,  AskLogin , et  NotConnectedScreen  sont les écrans d'accueil, 
  de connexion, et d'absence de connexion, respectivement. 
*/