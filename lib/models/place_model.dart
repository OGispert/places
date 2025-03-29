import 'dart:io';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Place {
  Place({required this.name, required this.image, required this.location})
    : id = uuid.v4();

  final String id;
  final String name;
  final File image;
  final PlaceLocation location;
}

class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;
}
