import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places/models/place_model.dart';

class MapView extends StatefulWidget {
  const MapView({
    super.key,
    this.location = const PlaceLocation(
      latitude: 40.400,
      longitude: -80.111,
      address: '',
    ),
    this.isSelecting = true,
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapView> createState() {
    return _MapViewState();
  }
}

class _MapViewState extends State<MapView> {
  LatLng? pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isSelecting ? 'Pick your location' : 'Your location',
        ),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(pickedLocation);
              },
              icon: Icon(Icons.save),
            ),
        ],
      ),
      body: GoogleMap(
        onTap:
            !widget.isSelecting
                ? null
                : (newLocation) {
                  setState(() {
                    pickedLocation = newLocation;
                  });
                },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 16,
        ),
        markers:
            (pickedLocation == null && widget.isSelecting)
                ? {}
                : {
                  Marker(
                    markerId: MarkerId('m1'),
                    position:
                        pickedLocation ??
                        LatLng(
                          widget.location.latitude,
                          widget.location.longitude,
                        ),
                  ),
                },
      ),
    );
  }
}
