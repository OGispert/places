import 'package:flutter/material.dart';
import 'package:places/models/place_model.dart';
import 'package:places/views/add_new_place.dart';
import 'package:places/views/place_details.dart';

class PlacesList extends StatefulWidget {
  const PlacesList({super.key});

  @override
  State<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  final List<Place> places = [];

  void addNewPlace() async {
    final newPlace = await Navigator.of(
      context,
    ).push<Place>(MaterialPageRoute(builder: (context) => AddNewPlace()));

    if (newPlace == null) {
      return;
    }

    setState(() {
      places.add(newPlace);
    });
  }

  void removePlace(Place place) {
    setState(() {
      places.remove(place);
    });
  }

  void placeDetails(Place place) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => PlaceDetails(place: place)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Places'),
        actions: [IconButton(onPressed: addNewPlace, icon: Icon(Icons.add))],
      ),
      body: ListView.builder(
        itemCount: places.length,
        itemBuilder:
            (context, index) => Dismissible(
              background: Container(
                color: const Color.fromARGB(255, 238, 40, 60),
              ),
              key: ValueKey(places[index].id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                removePlace(places[index]);
              },
              child: ListTile(
                title: Text(places[index].name),
                onTap: () {
                  placeDetails(places[index]);
                },
              ),
            ),
      ),
    );
  }
}
