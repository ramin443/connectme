import 'dart:async';

import 'package:connectme/constants/color_constants.dart';
import 'package:connectme/constants/font_constants.dart';
import 'package:connectme/constants/route_constants.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _duration = new Duration(seconds: 2);

  startTime() async {
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(userinforoute);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: appmainskyblue,
      body: Container(
        width: screenwidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: screenwidth * 0.08),
              child: Text(
                "Connect Me",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: screenwidth * 0.0814,
                    color: Colors.white,
                    fontFamily: tiemposfineregular),
              ),
            )
          ],
        ),
      ),
    );
  }
}
