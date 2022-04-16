import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'core/constant.dart';
import 'core/util.dart';
import 'module/home.dart';
import 'shared/slide_right_route.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int seconds = 3;

  @override
  void initState() {
    super.initState();
    setState(() {
      _getTimer(Home());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF91d0cc).withOpacity(1.0),
      body:_body(),
    );
  }

  _body(){
    double width = Util().getScreenHeight(context) * 0.25;
    double width1 = Util().getScreenHeight(context) * 0.2;
    double height = Util().getScreenHeight(context) * 0.15;
    double height1 = Util().getScreenHeight(context) ;
    double fontSize = Util().getScreenHeight(context) * 0.038;
    return Container(
      height: height1,
      // color: const Color(0xFF99d5cc).withOpacity(0.6),
      // color: Colors.white,
      // alignment: Alignment.center,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getLogo(height, width),
            Container(
              height: 10,
            ),
            _getAppTitle(
              title: Constant.APP_TITLE_NAME,
              fontSize: fontSize,
              width: width1,
            )
          ],
        ),
      ),
      // decoration: Util().boxDecoration(),
      // child: Util().getStyle(height,width ,fontSize),
    );
  }

  _getTimer(method) {
    return Timer(
      Duration(seconds: seconds),
      () => Navigator.pushReplacement(
        context,
        SlideRightRoute(
          page: method,
        ),
      ),
    );
  }

  _getLogo(height, width) {
    return Image.asset(
      'assets/logo.png',
      height: height,
      width: width,
    );
  }

  _getAppTitle(
      {required String title,
      required double fontSize,
      required double width}) {
    const colorizeColors = [
      Colors.blueGrey,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];
    return Util().getTextWithStyle1(title: "Counselinks", color: Colors.blueGrey.shade800, fontSize: fontSize, fontWeight: FontWeight.w400); SizedBox(
      width: width,
      child: AnimatedTextKit(
        repeatForever: true,
        animatedTexts: [
          ColorizeAnimatedText(
            title,
            textStyle: GoogleFonts.aBeeZee(
              fontWeight: FontWeight.w500,
              color: const Color(0xFF91d0cc),
              letterSpacing: 0.3,
              fontSize: fontSize,
            ),
            colors: colorizeColors,
          ),
        ],
        isRepeatingAnimation: true,
        onTap: () {
          print("Tap Event");
        },
      ),
    );
  }
}
