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
// import 'package:international_phone_input/international_phone_input.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'otpScreen.dart';

class AskLogin extends StatefulWidget {
  @override
  _AskLoginState createState() => _AskLoginState();
}

class _AskLoginState extends State<AskLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final controllPhone = TextEditingController(text: '+229');
  final controllName = TextEditingController();
  bool _autoValidate = false;
  late String _phone;
  late String _internationalPhoneNumber;
  late String _phoneIsoCode;
  bool checked = false;
  void _validateInputs() {
    if (_formKey.currentState!.validate()) {
      if (_internationalPhoneNumber == null) {
        Fluttertoast.showToast(
            msg: 'Numéro de téléphone non valide :( ',
            backgroundColor: Colors.red,
            fontSize: 18);
      } else {
        _formKey.currentState!.save();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OTP(
                      _internationalPhoneNumber,
                    )));
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      }
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _inputChange(
      String number, PhoneNumber internationlizedPhoneNumber, String? isoCode) {
    setState(() {
      _phoneIsoCode = isoCode!;
      _phone = number;
      if (internationlizedPhoneNumber.phoneNumber != null) {
        _internationalPhoneNumber = internationlizedPhoneNumber.phoneNumber!;
      }
    });
  }

  MobileLogin() {
    _scaffoldKey.currentState!.showBottomSheet((BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            child: Container(
              color: AppColors.tertiary,
              child: ListView(children: <Widget>[
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Mobile Login",
                      style: GoogleFonts.lora(
                          textStyle: TextStyle(
                              color: AppColors.primary,
                              fontSize: 30,
                              fontWeight: FontWeight.w700))),
                )),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Theme(
                          data: ThemeData(
                            primaryColor: AppColors.primary,
                            focusColor: AppColors.primary,
                          ),
                          child: InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {
                              _inputChange(number.phoneNumber ?? '', number,
                                  number.isoCode);
                            },
                            selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            ),
                            ignoreBlank: false,
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle:
                                TextStyle(color: AppColors.primary),
                            initialValue: PhoneNumber(isoCode: 'BJ'),
                            textFieldController: controllPhone,
                            formatInput: true,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            inputBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                          ),

                          // InternationalPhoneInput(
                          //   //border: OutlineInputBorder(borderSide: BorderSide(color:AppColors.primary,width:2,style:BorderStyle.solid)),
                          //   initialPhoneNumber: _phone,
                          //   initialSelection: '+91',
                          //   onPhoneNumberChange: _inputChange,
                          //   decoration: InputDecoration(
                          //     hintText: 'phone number',
                          //     fillColor: AppColors.primary,
                          //     focusColor: AppColors.primary,
                          //     enabledBorder: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(25),
                          //         borderSide: BorderSide(
                          //             color: AppColors.primary, width: 2)),
                          //     border: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(25),
                          //         borderSide: BorderSide(
                          //             color: AppColors.primary, width: 2.5)),
                          //     hintStyle: TextStyle(
                          //         fontWeight: FontWeight.w300,
                          //         fontSize: 18,
                          //         color: AppColors.primary),
                          //   ),
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _validateInputs(),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      disabledForegroundColor:
                          AppColors.primary.withOpacity(0.38),
                      disabledBackgroundColor: AppColors.primary
                          .withOpacity(0.12), // Ajout de onSurface
                      textStyle: const TextStyle(
                          color:
                              Colors.white), // Pour changer la couleur du texte
                    ),
                    child: const Text(
                      "Obtenir le code de vérification",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ]),
            )),
      );
    });
  }

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
            SignInButton(Buttons.GoogleDark, onPressed: () {
              if (checked)
                signInWithGoogle(context);
              else {
                Fluttertoast.showToast(
                    gravity: ToastGravity.TOP,
                    msg: "Accepter la politique de confidentialité!",
                    backgroundColor: Colors.redAccent,
                    textColor: Colors.white);
              }
            }),
            //Décommenter pour activer la connection avec un numéro de téléphone
            //Mais un problème avec Firebase OTP non encore résolu
            // SizedBox(height: height / 50),
            // OutlinedButton(
            //   style: OutlinedButton.styleFrom(
            //     foregroundColor: AppColors.primary,
            //     side: BorderSide(color: AppColors.primary, width: 2.0),
            //     disabledForegroundColor: AppColors.tertiary.withOpacity(0.38),
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(
            //             30.0)), // Couleur lors de la pression
            //   ),
            //   onPressed: () {
            //     if (checked)
            //       MobileLogin();
            //     else {
            //       Fluttertoast.showToast(
            //         gravity: ToastGravity.TOP,
            //         msg: "Consulter la politique de confidentialité",
            //         backgroundColor: Colors.redAccent,
            //         textColor: Colors.white,
            //       );
            //     }
            //   },
            //   child: Container(
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: <Widget>[
            //         const Icon(Icons.phone),
            //         Text(
            //           "Avec votre numéro de téléphone",
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             color: AppColors.primary,
            //             fontSize: 20,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
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
                const TextSpan(text: "of EventOS.")
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

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.icon,
      required this.hint,
      this.obsecure = false,
      required this.validator,
      required this.controller,
      required this.maxLines,
      required this.minLines,
      required this.onSaved,
      required this.radius,
      required this.number,
      required this.color,
      required this.width,
      required this.onChanged});

  final TextEditingController controller;
  final FormFieldSetter<String> onSaved;
  final FormFieldSetter<String> onChanged;
  final int maxLines;
  final int minLines;
  final Icon icon;
  final String hint;
  final bool obsecure;
  final bool number;
  final double radius;
  final Color color;
  final double width;

  final FormFieldValidator<String> validator;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: TextFormField(
        onChanged: onChanged,
        onSaved: onSaved,
        validator: validator,
        maxLines: maxLines,
        minLines: minLines,
        obscureText: obsecure,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        style: TextStyle(fontSize: 20, color: AppColors.primary),
        decoration: InputDecoration(
            hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.primary),
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(
                color: color,
                width: 2,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(
                color: color,
                width: width,
              ),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 25, right: 10),
              child: IconTheme(
                data: IconThemeData(color: AppColors.primary),
                child: icon,
              ),
            )),
      ),
    );
  }
}
