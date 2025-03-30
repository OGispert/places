import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/providers/places_provider.dart';
import 'package:places/views/add_new_place.dart';
import 'package:places/widgets/place_list.dart';

class Places extends ConsumerStatefulWidget {
  const Places({super.key});

  @override
  ConsumerState<Places> createState() {
    return _PlacesState();
  }
}

class _PlacesState extends ConsumerState<Places> {
  late Future<void> storedPlaces;

  @override
  void initState() {
    super.initState();
    storedPlaces = ref.read(placesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => AddNewPlace()));
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: storedPlaces,
        builder:
            (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator.adaptive())
                    : PlaceList(places: places),
      ),
    );
  }
}
