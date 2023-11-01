import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_project/config/config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
  AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? login = prefs.getBool('login');
  await FlutterConfig.loadEnvVariables();

  final connected = await checkInternetConnection();
  if (connected) {
    runApp(login == null
        ? MyApp1()
        : login
            ? MyApp()
            : MyApp1());
  } else {
    runApp(MyApp2());
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

class MyApp extends StatelessWidget {
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
      home: HomePage(),
      routes: {
        'login': (context) => AskLogin(),
        'homepage': (context) => HomePage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyApp1 extends StatelessWidget {
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
      home: AskLogin(),
      routes: {
        'login': (context) => AskLogin(),
        'homepage': (context) => HomePage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyApp2 extends StatelessWidget {
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
        'login': (context) => AskLogin(),
        'homepage': (context) => HomePage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class NotConnectedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/Connection_Lost.png',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          const Positioned(
            bottom: 200,
            left: 30,
            child: Text('Pas de Connexion',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                )),
          ),
          const Positioned(
            bottom: 150,
            left: 30,
            child: Text(
              'S\'il vous plaît, vérifiez votre connexion internet \net réessayer.',
              style: TextStyle(
                color: Colors.black38,
                fontSize: 16,
                letterSpacing: 1,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Positioned(
              bottom: 50,
              left: 40,
              right: 40,
              child: InkWell(
                onTap: () {
                  main();
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blue[800]!,
                  ),
                  child: Center(
                      child: Text(
                    'Réessayer'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                ),
              )),
        ],
      ),
    );
  }
}
