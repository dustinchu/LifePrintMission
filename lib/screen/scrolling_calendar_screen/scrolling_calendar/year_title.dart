import 'package:flutter/material.dart';
import 'utils/screen_sizes.dart';

class YearTitle extends StatelessWidget {
  const YearTitle(
    this.year,
  );

  final int year;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        year.toString(),
        style: TextStyle(
          fontSize: screenSize(context) == ScreenSizes.small ? 22.0 : 26.0,
          fontWeight: FontWeight.w600,
          color:Color.fromRGBO(255, 105, 105, 1)
        ),
      ),
    );
  }
}
