import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/common/extra/color.dart';
import 'package:text_print_3d/state/date_status.dart';

class HomeItemRightChild extends StatelessWidget {
  HomeItemRightChild({Key key, @required this.item}) : super(key: key);
  var item;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 90,
      child: Column(
        children: [
          Container(
            height: 38,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)),
            ),
            width: double.infinity,
            child: InkWell(
              onTap: () {
                Provider.of<DateStatus>(context, listen: false)
                    .listDataDeleteEvent(item.id);
                print(item.id.toString());
              },
              child: Center(
                child: Text(
                  "Delete",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.selectBackroundColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: new BoxDecoration(
                color: AppColors.selectBackroundColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
              ),
              width: double.infinity,
              child: Center(
                child: Text(" Move to \ntomorrow",
                    style: TextStyle(fontSize: 12, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
