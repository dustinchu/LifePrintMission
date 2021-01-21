import 'package:flutter/material.dart';
import 'package:text_print_3d/common/extra/color.dart';

class WelcomeBotoomRow extends StatelessWidget {
  const WelcomeBotoomRow({@required this.sheet, this.btn, Key key})
      : super(key: key);
  final int sheet;
  final btn;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _circule(sheet == 1 ? true : false),
        SizedBox(
          width: 20,
        ),
        _circule(sheet == 2 ? true : false),
        SizedBox(
          width: 20,
        ),
        _circule(sheet == 3 ? true : false),
        Expanded(child: Container()),
        sheet == 3 ? _nextBtn() : _next(),
      ],
    );
  }

  Widget _nextBtn() {
    return FlatButton(
      height: 55,
      minWidth: 188,
      onPressed: btn,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
          ),
          Text(
            "Get Start",
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Icon(
            Icons.chevron_right,
            size: 40,
            color: Colors.white,
          ),
        ],
      ),
      color: AppColors.selectBackroundColor,
      textColor: Colors.black,
      shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(30)),
    );
  }

  Widget _next() {
    return Material(
      child: InkWell(
        onTap: btn,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            color: AppColors.circulayColor,
          ),
          child: Icon(
            Icons.chevron_right,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _circule(bool color) {
    return Container(
      width: 11,
      height: 11,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: color ? AppColors.circulayColor : AppColors.defCirculayColor,
      ),
    );
  }
}
