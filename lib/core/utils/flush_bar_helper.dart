import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarHelper{
  static void show(String title, message) {
    Get.snackbar(
        title, message,
      backgroundColor: Colors.white,
      colorText: Colors.black,
    );
  }
}
