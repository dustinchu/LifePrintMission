import 'package:flutter/material.dart';
import 'package:text_print_3d/common/extra/color.dart';

Widget progress() {
  return Center(
    child: CircularProgressIndicator(
      valueColor:
          new AlwaysStoppedAnimation<Color>(AppColors.selectBackroundColor),
    ),
  );
}
