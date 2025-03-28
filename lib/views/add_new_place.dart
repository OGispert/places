import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/models/place_model.dart';
import 'package:places/providers/places_provider.dart';
import 'package:places/widgets/image_input.dart';
import 'dart:io';

import 'package:places/widgets/location_input.dart';

class AddNewPlace extends ConsumerStatefulWidget {
  const AddNewPlace({super.key});

  @override
  ConsumerState<AddNewPlace> createState() => _AddNewPlaceState();
}

class _AddNewPlaceState extends ConsumerState<AddNewPlace> {
  final formKey = GlobalKey<FormState>();
  var enteredPlaceName = '';
  File? selectedImage;

  void savePlace() {
    if (selectedImage == null) {
      // show an alert
      return;
    }

    if (formKey.currentState?.validate() == true) {
      formKey.currentState?.save();

      final newPlace = Place(name: enteredPlaceName, image: selectedImage!);

      ref.read(placesProvider.notifier).addPlace(newPlace);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Place')),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(labelText: 'Place name'),
                  onTapOutside: (PointerDownEvent event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  keyboardType: TextInputType.name,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 50) {
                      return 'Name must be between 1 and 50 characters.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredPlaceName = value ?? "";
                  },
                ),
                SizedBox(height: 16),
                ImageInput(
                  onPickImage: (image) {
                    selectedImage = image;
                  },
                ),
                SizedBox(height: 16),
                LocationInput(),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        formKey.currentState?.reset();
                      },
                      child: const Text('Reset'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: savePlace,
                      icon: Icon(Icons.add),
                      label: const Text('Save Place'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
