// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'image_picker_dialog.dart';

ImagePickerDialog? imagePicker;

class ImagePickerHandler {
  AnimationController _controller;
  ImagePickerListener _listener;
  ImagePicker _picker = ImagePicker();

  ImagePickerHandler(
    this._controller,
    this._listener,
  );

  openCamera() async {
    imagePicker!.dismissDialog();
    var image = await _picker.getImage(source: ImageSource.camera);
    cropImage(image!);
  }

  openGallery() async {
    imagePicker!.dismissDialog();
    var image = await _picker.getImage(source: ImageSource.gallery);
    cropImage(image!);
  }

  void init() {
    imagePicker = ImagePickerDialog(_listener, _controller);
    imagePicker!.initState();
  }

  Future cropImage(PickedFile? image) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    _listener.userImage(File(croppedFile!.path));
  }

  showDialog(BuildContext context) {
    imagePicker!.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
}

class Utils {
  Utils._();

  /// Open image gallery and pick an image
  static Future<XFile?> pickImageFromGallery() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  /// Open camera and pick an image
  static Future<XFile?> pickImageFromCamera() async {
    return await ImagePicker().pickImage(source: ImageSource.camera);
  }

  /// Pick Image From Gallery and return a File
  static Future<CroppedFile?> cropSelectedImage(String filePath) async {
    return await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
  }
}
