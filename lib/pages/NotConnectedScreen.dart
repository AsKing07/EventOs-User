import 'package:flutter/material.dart';
import 'package:flutter_project/main.dart';

class NotConnectedScreen extends StatelessWidget {
  const NotConnectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image de fond
          Image.asset(
            'assets/Connection_Lost.png',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          // Texte "Pas de Connexion"
          const Positioned(
            bottom: 200,
            left: 30,
            child: Text(
              'Pas de Connexion',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                letterSpacing: 1,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Texte "Veuillez vous connecter à internet!"
          const Positioned(
            bottom: 150,
            left: 30,
            child: Text(
              'Veuillez vous connecter à internet!',
              softWrap: true,
              style: TextStyle(
                color: Colors.black38,
                fontSize: 16,
                letterSpacing: 1,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          // Bouton "Réessayer"
          Positioned(
            bottom: 50,
            left: 40,
            right: 40,
            child: InkWell(
              onTap: () {
                main(); // Appelle la fonction main pour réessayer la connexion
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
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/*
Dans ce code : 
 
- Le widget  NotConnectedScreen  est un écran affiché lorsque l'application n'est pas connectée à Internet. 
 
- Le widget  Stack  est utilisé pour empiler les éléments les uns sur les autres et les positionner. Sans Stack, on ne peut pas positionner 
 
- Le widget  Image.asset  affiche une image de fond avec l'asset 'Connection_Lost.png'. 
 
- Les widgets  Positioned  sont utilisés pour positionner les éléments de texte "Pas de Connexion" et "Veuillez vous connecter à internet!"
   à des emplacements spécifiques sur l'écran. 
 
- Le widget  InkWell  est utilisé pour créer un bouton réactif qui appelle la fonction  main  lorsque l'utilisateur appuie dessus. 
 
- Le widget  Container  est utilisé pour définir la taille et la décoration du bouton. 
 
- Le widget  Text  est utilisé pour afficher le texte "Réessayer". 
 
*/