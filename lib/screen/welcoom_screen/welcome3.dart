import 'package:flutter/material.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:text_print_3d/common/extra/color.dart';
import 'package:text_print_3d/common/extra/style.dart';
import 'package:text_print_3d/screen/home_screen/home_screen.dart';

import 'bottom.dart';

class Welcome3Screen extends StatelessWidget {
  const Welcome3Screen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void next() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ));
    }

    void _onHorizontalSwipe(SwipeDirection direction) {
      if (direction == SwipeDirection.left) {
       Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomeScreen(),
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
          padding: const EdgeInsets.only(top: 100.0, left: 30, right: 30),
          child: Column(
            children: [
              Image.asset(
                'assets/icon/welcome3.png',
                height: 431,
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enjoy It",
                    style: welcomeTitle,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Start your LIFE MISSION now! \n" "",
                    style: welcomeBody,
                  ),
                  SizedBox(height: 70),
                  WelcomeBotoomRow(sheet: 3, btn: next),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
