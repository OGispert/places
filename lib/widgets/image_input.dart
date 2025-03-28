import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  final isAndroid = Platform.isAndroid;
  File? selectedImage;

  void takePicture() async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 600,
    );

    if (image == null) {
      return;
    }

    setState(() {
      selectedImage = File(image.path);
    });

    widget.onPickImage(selectedImage ?? File(''));
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: takePicture,
      label: Text('Take a picture.'),
      icon: Icon(isAndroid ? Icons.camera : Icons.camera_alt),
    );

    if (selectedImage != null) {
      content = GestureDetector(
        onTap: takePicture,
        child: Image.file(
          selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withAlpha(100),
        ),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
