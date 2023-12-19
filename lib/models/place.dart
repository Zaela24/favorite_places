import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  const PlaceLocation({
    required this.lat,
    required this.long,
    required this.address,
  });

  final double lat;
  final double long;
  final String address;
}

class Place {
  Place({
    required this.title,
    required this.image,
    required this.location,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
}
