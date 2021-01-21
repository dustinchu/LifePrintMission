import 'package:flutter/material.dart';
import 'utils/dates.dart';

class MonthTitle extends StatelessWidget {
  const MonthTitle({
    @required this.month,
    this.monthNames,
    this.style = const TextStyle(
   
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  });

  final int month;
  final List<String> monthNames;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Center(
            child: Text(
              
              getMonthName(month, monthNames: monthNames),
              style: style,
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
          ),
        ),
         Container(
           height: 0.5,
           width: double.infinity,
           color:Color.fromRGBO(113, 214, 209, 1)
        ),
      ],
    );
  }
}
