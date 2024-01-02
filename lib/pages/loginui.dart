// ignore_for_file: unnecessary_null_comparison, unused_field

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_project/config/config.dart';
import 'package:flutter_project/config/size.dart';
import 'package:flutter_project/Methods/googleSignIn.dart';
import 'package:flutter_project/pages/policy.dart';
import '../Widgets/clipper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class AskLogin extends StatefulWidget {
  const AskLogin({super.key});

  @override
  _AskLoginState createState() => _AskLoginState();
}

class _AskLoginState extends State<AskLogin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool checked = false;

  @override
  Widget build(BuildContext context) {
    double height = SizeConfig.getHeight(context);
    double width = SizeConfig.getWidth(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(children: <Widget>[
        SizedBox(
          height: height / 20,
        ),
        Expanded(
            child: Image.asset(
          'assets/logo.png',
          height: 70,
        )),
        Expanded(
          child: Center(
            child: RichText(
                text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: "Event",
                  style: GoogleFonts.lora(
                      textStyle: TextStyle(
                          color: AppColors.primary,
                          fontSize: 45,
                          fontWeight: FontWeight.bold))),
              TextSpan(
                  text: "OS",
                  style: GoogleFonts.lora(
                      textStyle: TextStyle(
                          color: AppColors.primary,
                          fontSize: 45,
                          fontWeight: FontWeight.bold))),
            ])),
          ),
        ),
        SizedBox(
          height: height / 20,
        ),
        SvgPicture.asset(
          'assets/login.svg',
          width: width,
          height: height / 3,
        ),
        SizedBox(height: height / 10),
        Column(
          children: <Widget>[
            SignInButton(
              Buttons.GoogleDark,
              onPressed: () {
                if (checked) {
                  signInWithGoogle(context);
                } else {
                  Fluttertoast.showToast(
                      gravity: ToastGravity.TOP,
                      msg: "Accepter la politique de confidentialité!",
                      backgroundColor: Colors.redAccent,
                      textColor: Colors.white);
                }
              },
              text: "Se connecter avec Google",
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: Text.rich(TextSpan(children: [
                const TextSpan(text: "Accepter"),
                TextSpan(
                    text: " Politiques de confidentialité",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Policy()));
                      },
                    style: const TextStyle(
                        color: Colors.blue, fontStyle: FontStyle.italic)),
                const TextSpan(text: ', '),
                TextSpan(
                    text: "Termes & conditions",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Policy()));
                      },
                    style: const TextStyle(
                        color: Colors.blue, fontStyle: FontStyle.italic)),
                const TextSpan(text: ' & '),
                TextSpan(
                    text: "Politique d'annulation ",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Policy()));
                      },
                    style: const TextStyle(
                        color: Colors.blue, fontStyle: FontStyle.italic)),
                const TextSpan(text: "de EventOS.")
              ])),
              value: checked,
              onChanged: (newValue) {
                setState(() {
                  checked = newValue!;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            )
          ],
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(
                color: AppColors.secondary,
                height: 300,
              ),
            ),
          ),
        )
      ]),
    );
  }
}



// Ce code est la classe qui représente la page d'authentification. Voici une explication détaillée du code :

// - Les imports importent les packages nécessaires pour le fonctionnement de la page.
// - La classe  `AskLogin`  est un widget StatefulWidget qui représente la page d'authentification.
// - Le widget  `AskLogin`  a un état représenté par la classe  `_AskLoginState` .
// - Le  `_AskLoginState`  a une clé  `GlobalKey<ScaffoldState>`  utilisée pour accéder au Scaffold parent.
// - La variable  `checked`  est un booléen qui représente si l'utilisateur a accepté les politiques de confidentialité.
// - Le widget  `build`  est la méthode qui construit l'interface utilisateur de la page.
// - La page est organisée en colonnes et utilise des widgets tels que SizedBox, Expanded, Image, Center, RichText, SvgPicture, SignInButton et CheckboxListTile pour créer l'interface utilisateur.
// - Lorsque l'utilisateur appuie sur le bouton "Se connecter avec Google" et que la case à cocher est cochée, la méthode  `signInWithGoogle`  est appelée.
// - Si la case à cocher n'est pas cochée, un message d'erreur est affiché à l'aide de Fluttertoast.
// - Lorsque l'utilisateur coche ou décoche la case à cocher, la variable  `checked`  est mise à jour en utilisant la méthode  `setState` .
// - Le bas de la page utilise le widget ClipPath pour créer une forme d'onde en bas de la page.

