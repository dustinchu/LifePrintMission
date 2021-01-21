import 'package:flutter/material.dart';
import 'package:text_print_3d/common/extra/color.dart';

class RowTitleText extends StatelessWidget {
  const RowTitleText({Key key, @required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: AppColors.settingTitleColor,
          fontSize: 24,
          fontWeight: FontWeight.bold),
    );
  }
}
