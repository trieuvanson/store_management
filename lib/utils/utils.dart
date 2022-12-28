import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

pickImage(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();
  XFile? _file = await _picker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  return null;
}



convertToVND(number) {
  var currencyString = NumberFormat.currency(locale: 'vi', symbol: '₫').format(number);
  return currencyString;
}

//showToast

showToastErr(String messenger) {
  Get.snackbar(
      "Thông báo",
      messenger,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
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
          Get.back();
        },
        child: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      )
  );
}

showToastSuccess(String message) {
  Get.snackbar(
    "Thông báo",
    message,
    snackPosition: SnackPosition.BOTTOM,
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
        Get.back();
      },
      child: const Icon(
        Icons.close,
        color: Colors.white,
      ),
    )
  );
}