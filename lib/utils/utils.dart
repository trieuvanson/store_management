import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

pickImage(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();
  XFile? _file = await _picker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  return null;
}

showSnackBar(String content, BuildContext context, {int? duration, Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: Duration(milliseconds: duration ?? 300),
    content: Text(content),
    backgroundColor: color??Vx.gray700,
  ));
}

_showSnackBar(
    {required String content,
    required int seconds,
    required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: Duration(seconds: seconds),
    content: Text(content),
  ));
}
