import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/models/place_model.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super(const []);

  Future<Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'user_places.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, name TEXT, image TEXT, lat REAL, long REAL, address TEXT)',
        );
      },
      version: 1,
    );
    return db;
  }

  void addPlace(Place place) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(place.image.path);
    final copiedImage = await place.image.copy('${appDir.path}/$filename');

    final newPlace = Place(
      name: place.name,
      image: copiedImage,
      location: place.location,
    );

    final db = await _getDatabase();

    db.insert('user_places', {
      'id': newPlace.id,
      'name': newPlace.name,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'long': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    state = [newPlace, ...state];
  }

  void removePlace(Place place) async {
    final itExists = state.contains(place);
    final db = await _getDatabase();

    if (itExists) {
      db.delete('user_places', where: 'id = ?', whereArgs: [place.id]);
      state = state.where((item) => item.id != place.id).toList();
    }
  }

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final storedPlaces =
        data
            .map(
              (row) => Place(
                id: row['id'] as String,
                name: row['name'] as String,
                image: File(row['image'] as String),
                location: PlaceLocation(
                  latitude: row['lat'] as double,
                  longitude: row['long'] as double,
                  address: row['address'] as String,
                ),
              ),
            )
            .toList();

    state = storedPlaces;
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>((
  ref,
) {
  return PlacesNotifier();
});
