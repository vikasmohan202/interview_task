import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagepicker = ImagePicker();

  XFile? file = await _imagepicker.pickImage(source: source);

  if(file!=null){
    return file.readAsBytes();
  }
  print('No image selected');
}