import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  static Color primaryColor = const Color(0xFF174F4F);
}



void customeMessage(String title, String message, Icon icon) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    colorText: Colors.white,
    borderRadius: 10,
    backgroundColor: AppColors.primaryColor,
    icon: icon,
  );
}
