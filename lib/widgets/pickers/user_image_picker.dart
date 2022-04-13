import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../view_models/user_viewmodel.dart';

class UserImagePicker extends StatefulWidget {
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  List<bool> isSelected = [false, false];
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
        SizedBox(
          height: 16,
        ),
        DottedBorder(
          borderType: BorderType.Circle,
          dashPattern: [12, 4],
          color: Color.fromRGBO(34, 72, 113, 0.8),
          strokeWidth: 2,
          child: CircleAvatar(
            radius: 52,
            child: Icon(
              Icons.image,
              color: Color.fromRGBO(34, 72, 113, 0.8),
            ),
            backgroundColor: Colors.transparent,
            backgroundImage:
                _pickedImageFile == null ? null : FileImage(_pickedImageFile!),
          ),
        ),
        TextButton(
          onPressed: () async {
            final pickedImage = await _pickImage();
            userViewModel.userImageFile = pickedImage;
          },
          child: Text('Add Image'),
          style: TextButton.styleFrom(
              textStyle: TextStyle(
                  color: Color.fromRGBO(34, 72, 113, 0.8),
                  fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
