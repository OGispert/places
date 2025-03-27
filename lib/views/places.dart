import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/providers/places_provider.dart';
import 'package:places/views/add_new_place.dart';
import 'package:places/widgets/place_list.dart';

class Places extends ConsumerWidget {
  const Places({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: PlaceList(places: places),
    );
  }
}
