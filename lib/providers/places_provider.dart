import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/models/place_model.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super(const []);

  void addPlace(Place newPlace) {
    state = [newPlace, ...state];
  }

  void removePlace(Place place) {
    final itExists = state.contains(place);

    if (itExists) {
      state = state.where((item) => item.id != place.id).toList();
    }
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>((
  ref,
) {
  return PlacesNotifier();
});
