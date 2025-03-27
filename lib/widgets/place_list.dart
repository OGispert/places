import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/models/place_model.dart';
import 'package:places/providers/places_provider.dart';
import 'package:places/views/place_details.dart';

class PlaceList extends ConsumerStatefulWidget {
  const PlaceList({super.key, required this.places});

  final List<Place> places;

  @override
  ConsumerState<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends ConsumerState<PlaceList> {
  void removePlace(Place place) {
    ref.read(placesProvider.notifier).removePlace(place);
  }

  void placeDetails(Place place) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => PlaceDetails(place: place)));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.places.isEmpty) {
      return Center(
        child: Text(
          'There are no places added yet.',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }
    return ListView.builder(
      itemCount: widget.places.length,
      itemBuilder:
          (context, index) => Dismissible(
            background: Container(
              color: const Color.fromARGB(255, 238, 40, 60),
            ),
            key: ValueKey(widget.places[index].id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              removePlace(widget.places[index]);
            },
            child: ListTile(
              title: Text(
                widget.places[index].name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                placeDetails(widget.places[index]);
              },
            ),
          ),
    );
  }
}
