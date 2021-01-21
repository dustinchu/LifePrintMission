import 'package:flutter/material.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:text_print_3d/common/extra/color.dart';
import 'package:text_print_3d/common/extra/style.dart';

import 'bottom.dart';
import 'welcome3.dart';

class Welcome2Screen extends StatelessWidget {
  const Welcome2Screen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void next() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Welcome3Screen(),
      ));
    }

    void _onHorizontalSwipe(SwipeDirection direction) {
      if (direction == SwipeDirection.left) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Welcome3Screen(),
        ));
        print('Swiped left!');
      } else {
        Navigator.of(context).pop();
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
                'assets/icon/welcome2.png',
                height: 431,
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bluetooth",
                    style: welcomeTitle,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Turn on your phone’s bluetooth mode \nand connect it to the hardware.",
                    style: welcomeBody,
                  ),
                  SizedBox(height: 70),
                  WelcomeBotoomRow(sheet: 2, btn: next),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
