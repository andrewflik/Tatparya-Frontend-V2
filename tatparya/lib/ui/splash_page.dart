// Splash Loading Screen
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:tatparya/ui/intro_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPage createState() => _SplashPage();
}

class _SplashPage extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget _body() {
    return Scaffold(
      body: SplashScreen(
          seconds: 4,
          navigateAfterSeconds: IntroPage(),
          image: Image.asset(
            'images/tatparya.gif',
            fit: BoxFit.fill,
          ),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: TextStyle(fontSize: 22),
          loadingText: Text(
            "Loading ...",
          ),
          photoSize: 200.0,
          loaderColor: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }
}
