import 'package:flutter/material.dart';
import 'package:text_print_3d/common/extra/color.dart';

class HomeLayerImage extends StatelessWidget {
  final bool backround;
  final GestureTapCallback onTap;
  final String imgPath;
  final String text;
  const HomeLayerImage(
      {@required this.backround,
      @required this.onTap,
      @required this.imgPath,
      @required this.text,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: backround
              ? AppColors.frontLayerImgBackroundColor
              : Colors.transparent,
            ),
          width: 88,
          height: 88,
       
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              imgPath,
              width: 52,
              height: 52,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: 14,
                  color: AppColors.selectBackroundColor,
                  fontWeight: FontWeight.bold),
            )
          ]),
        ),
      ),
    );
  }
}
