import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);
  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImageFile = await picker.getImage(
        source: ImageSource.camera, imageQuality: 70, maxWidth: 150);

    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
    widget.imagePickFn(File(pickedImageFile!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 50,
            // ignore: unnecessary_null_comparison
            backgroundImage:
                _pickedImage != null ? FileImage(_pickedImage!) : null,
          ),
          TextButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image),
              label: Text('Add User Profile'))
        ],
      ),
    );
  }
}
