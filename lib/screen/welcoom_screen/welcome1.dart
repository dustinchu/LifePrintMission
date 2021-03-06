import 'package:flutter/material.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:text_print_3d/common/extra/color.dart';
import 'package:text_print_3d/common/extra/style.dart';
import 'package:text_print_3d/screen/welcoom_screen/welcome2.dart';

import 'bottom.dart';

class Welcome1Screen extends StatelessWidget {
  const Welcome1Screen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void next() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Welcome2Screen(),
      ));
    }

    void _onHorizontalSwipe(SwipeDirection direction) {
      if (direction == SwipeDirection.left) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Welcome2Screen(),
        ));
        print('Swiped left!');
      } else {
        print('Swiped right!');
      }
    }

    return SimpleGestureDetector(
      onHorizontalSwipe: _onHorizontalSwipe,
       onTap: () {},
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0, left: 50, right: 50),
          child: Column(
            children: [
              Image.asset(
                'assets/icon/welcome1.png',
                height: 431,
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Plug In",
                    style: welcomeTitle,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Plug in the LIFE MISSION hardware \nand it would automatically turn on.",
                    style: welcomeBody,
                  ),
                  SizedBox(height: 70),
                  WelcomeBotoomRow(sheet: 1, btn: next),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
