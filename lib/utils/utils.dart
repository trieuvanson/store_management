import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

showSnackBar(String content, BuildContext context,
    {int? duration, Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: Duration(milliseconds: duration ?? 300),
    content: Text(content),
    backgroundColor: color ?? Vx.gray700,
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
Future<bool> handleWillPop(DateTime? currentBackPressTime, BuildContext context) async {
  final now = DateTime.now();
  final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
      currentBackPressTime == null ||
          now.difference(currentBackPressTime) > const Duration(seconds: 2);

  if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
    currentBackPressTime = now;
    Get.snackbar(
      'Thông báo',
      'Nhấn lần nữa để thoát',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      snackStyle: SnackStyle.FLOATING,
      animationDuration: const Duration(milliseconds: 300),
      duration: const Duration(seconds: 2),
      icon: const Icon(
        Icons.info,
        color: Colors.white,
      ),
      mainButton: TextButton(
        onPressed: () {
          //close the snackbar
          Get.back();
        },
        child: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
    );
    return false;
  }

  return true;
}

Future<bool> onWillPop(DateTime? currentBackPressTime, BuildContext context) async {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
    currentBackPressTime = now;
    Get.snackbar(
      'Thông báo',
      'Nhấn lần nữa để thoát',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      snackStyle: SnackStyle.FLOATING,
      animationDuration: const Duration(milliseconds: 300),
      duration: const Duration(seconds: 2),
      icon: const Icon(
        Icons.info,
        color: Colors.white,
      ),
      mainButton: TextButton(
        onPressed: () {
          //close the snackbar
          Get.back();
        },
        child: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
    );
    return Future.value(false);
  }
  Get.back();
  return Future.value(true);
}
