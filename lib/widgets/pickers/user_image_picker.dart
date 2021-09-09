import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../view_models/user_viewmodel.dart';

class UserImagePicker extends StatefulWidget {
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;
  final picker = ImagePicker();

  Future<File?> _pickImage() async {
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImageFile = pickedImage != null ? File(pickedImage.path) : null;
    });
    return _pickedImageFile;
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImageFile == null ? null : FileImage(_pickedImageFile!),
        ),
        TextButton.icon(
          onPressed: () async {
            final pickedImage = await _pickImage();
            userViewModel.userImageFile = pickedImage;
          },
          icon: Icon(Icons.image),
          label: Text('Add Image'),
          style: TextButton.styleFrom(
              textStyle: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ],
    );
  }
}
