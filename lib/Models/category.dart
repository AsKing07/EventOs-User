import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Category {
  final int? categoryId;
  final String? name;
  final IconData? icon;
  final String? value;

  Category({this.categoryId, this.name, this.icon, this.value});
}

final allCategory = Category(
  categoryId: 0,
  name: "Tous",
  value: "All Events",
  icon: Icons.search,
);

final concertCategory = Category(
  categoryId: 1,
  name: "Concert",
  value: "Concert/Performance",
  icon: Icons.speaker_group_sharp,
);

final musicCategory = Category(
  categoryId: 2,
  name: "Prestation/Chant",
  value: "Appearance/Singing",
  icon: Icons.music_note,
);

final meetUpCategory = Category(
  categoryId: 3,
  name: "Rencontre",
  value: 'Attaraction',
  icon: FontAwesomeIcons.meetup,
);

final festivalCategory = Category(
  categoryId: 4,
  name: "Festival/Foire",
  value: 'Festival or Fair',
  icon: Icons.festival_outlined,
);

final dinerCategory = Category(
  categoryId: 5,
  name: "Dinner/Gala",
  value: 'Dinner or Gala',
  icon: Icons.dining_sharp,
);

final conventionCategory = Category(
  categoryId: 6,
  name: "Convention",
  value: 'Convention',
  icon: FontAwesomeIcons.microphone,
);

final conferenceCategory = Category(
    categoryId: 7, name: "Conférence", value: 'Conference', icon: Icons.sms);

final workCategory = Category(
  categoryId: 2,
  name: "Cours/Formation",
  value: 'Class, Training, or Workshop',
  icon: FontAwesomeIcons.school,
);

final travelCategory = Category(
  categoryId: 8,
  name: "Camp/Voyage",
  value: 'Camp, Trip or Retreat',
  icon: FontAwesomeIcons.plane,
);

final meetingCategory = Category(
  categoryId: 9,
  name: "Meeting/Réseautage",
  value: "Meeting/Networking",
  icon: Icons.meeting_room,
);

final chillCategory = Category(
  categoryId: 11,
  name: "Social/Chill",
  value: 'Party/Social Gathering',
  icon: Icons.celebration,
);

final gameCategory = Category(
  categoryId: 12,
  name: "Jeu",
  value: 'Game or Competition',
  icon: Icons.gamepad_outlined,
);

final otherCategory = Category(
  categoryId: 13,
  name: "Autre",
  value: 'Other',
  icon: FontAwesomeIcons.search,
);

final categories = [
  allCategory,
  concertCategory,
  musicCategory,
  meetUpCategory,
  festivalCategory,
  workCategory,
  dinerCategory,
  conventionCategory,
  conferenceCategory,
  travelCategory,
  meetingCategory,
  chillCategory,
  gameCategory,
  otherCategory
];
