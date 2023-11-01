import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  icon: Icons.music_note,
);

final musicCategory = Category(
  categoryId: 2,
  name: "Prestation",
  value: "Appearance/Singing",
  icon: Icons.music_note,
);

final meetUpCategory = Category(
  categoryId: 3,
  name: "Rencontre",
  value: 'Attaraction',
  icon: Icons.location_on,
);

final festivalCategory = Category(
  categoryId: 4,
  name: "Festival",
  value: 'Festival or Fair',
  icon: Icons.location_on,
);

final dinerCategory = Category(
  categoryId: 5,
  name: "Dinner/Gala",
  value: 'Dinner or Gala',
  icon: Icons.location_on,
);

final conventionCategory = Category(
  categoryId: 6,
  name: "Convention",
  value: 'Convention',
  icon: Icons.location_on,
);

final conferenceCategory = Category(
  categoryId: 7,
  name: "Conférence",
  value: 'Conference',
  icon: Icons.location_on,
);

final workCategory = Category(
  categoryId: 2,
  name: "Formation",
  value: 'Class, Training, or Workshop',
  icon: Icons.location_on,
);

final travelCategory = Category(
  categoryId: 8,
  name: "Voyage",
  value: 'Camp, Trip or Retreat',
  icon: Icons.location_on,
);

final meetingCategory = Category(
  categoryId: 9,
  name: "Meeting/Réseautage",
  value: "Meeting/Networking",
  icon: Icons.golf_course,
);

final chillCategory = Category(
  categoryId: 11,
  name: "Rassemblement social/Chill",
  value: 'Party/Social Gathering',
  icon: Icons.cake,
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
  icon: Icons.cake,
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
