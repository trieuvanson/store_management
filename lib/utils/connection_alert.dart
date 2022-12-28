import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ConnectionAlertSupport {
  static void showConnectionAlert(BuildContext context, String message,
          {String? title, Color? color}) =>
      //A container overlay that shows the message, no time limit
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: color ?? Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

  showAlertBottom(
          {required String title, required String message, Color? color}) =>
      //A container overlay that shows the message, no time limit
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: color ?? Colors.green,
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
        ),
      );
}

final connectionAlertSupport = ConnectionAlertSupport();
