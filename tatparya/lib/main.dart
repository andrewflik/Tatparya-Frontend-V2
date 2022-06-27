/* 
  Author - Devesh
*/
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ui/intro_page.dart';
import 'ui/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tatparya.io',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: <String, WidgetBuilder>{
        "/splash": (BuildContext context) => SplashPage(),
        //"/intro": (BuildContext context) => IntroPage(),
      },
    );
  }
}
