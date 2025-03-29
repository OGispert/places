import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:places/models/place_model.dart';
import 'package:places/views/map.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? userLocation;
  var isGettingLocation = false;
  final googleAPIKey = '';

  String get locationImage {
    final lat = userLocation?.latitude;
    final long = userLocation?.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:P%7C$lat,$long&key=$googleAPIKey';
  }

  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      isGettingLocation = true;
    });

    locationData = await location.getLocation();

    final lat = locationData.latitude ?? 0.0;
    final long = locationData.longitude ?? 0.0;
    saveLocation(lat, long);
  }

  void selectOnMap() async {
    final newLocation = await Navigator.of(
      context,
    ).push<LatLng>(MaterialPageRoute(builder: (context) => MapView()));

    if (newLocation != null) {
      saveLocation(newLocation.latitude, newLocation.longitude);
    }
  }

  void saveLocation(double latitude, double longitude) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleAPIKey',
    );
    final response = await http.get(url);
    final responseData = jsonDecode(response.body);
    final address = responseData['results'][0]['formatted_address'];

    setState(() {
      userLocation = PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        address: address,
      );
      isGettingLocation = false;
    });

    if (userLocation != null) {
      widget.onSelectLocation(userLocation!);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location given.',
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
    );

    if (isGettingLocation) {
      previewContent = CircularProgressIndicator.adaptive();
    }

    if (userLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withAlpha(100),
            ),
          ),
          height: 180,
          width: double.infinity,
          child: Center(child: previewContent),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: getCurrentLocation,
              label: Text('Get current location.'),
              icon: Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: selectOnMap,
              label: Text('Select on map.'),
              icon: Icon(Icons.map),
            ),
          ],
        ),
      ],
    );
  }
}
