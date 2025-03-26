import 'package:flutter/material.dart';
import 'package:places/models/place_model.dart';

class PlaceDetails extends StatelessWidget {
  const PlaceDetails({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(place.name)));
  }
}
