// Intro Page
/*
    Intro Page 
*/

import 'dart:async';

import 'package:tatparya/ui/input_page.dart';
import 'package:tatparya/widgets/centered_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class IntroDetails extends StatefulWidget {
  IntroDetails({Key? key}) : super(key: key);

  @override
  _IntroDetails createState() => _IntroDetails();
}

class _IntroDetails extends State<IntroDetails> {
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Tatparya.io',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 65,
                height: 0.9,
                letterSpacing: -3.5),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Terms of service are often too long to read, but it's important to understand what's in them. Your rights online depend on them. We hope that our service can help you get informed about your rights and limitations.",
            style: TextStyle(
                fontSize: 21, height: 1.7, fontWeight: FontWeight.w300),
          ),
          SizedBox(height: 25),
          RoundedLoadingButton(
            child: Text(
              'Get Started',
              style: TextStyle(color: Colors.white),
            ),
            width: 125,
            controller: _btnController,
            onPressed: () {
              Timer(Duration(seconds: 2), () {
                _btnController.success();
                _btnController.reset();
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => InputPage()));
            },
          )
          /*MaterialButton(
            color: Colors.blue,
            child: Text(
              'Get Started',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
            },
          )*/
        ],
      ),
    );
  }
}

class MockUpImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(left: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            //height: screenSize.width / 3.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.asset(
                'images/motu.png',
                fit: BoxFit.cover,
                width: 500,
                height: 500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CenteredView(
        child: Column(
          children: <Widget>[
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(child: IntroDetails()),
                Flexible(
                  child: Center(
                    child: MockUpImage(),
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
