import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../homeScreen/homeScreen.dart';

class Splashscreen extends StatefulWidget {
  static const String routeName = "/Splashscreen";

  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  List<Color> colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  TextStyle colorizeTextStyle = TextStyle(
    fontSize: 50.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'Horizon',
  );

  Future<void> checkStatusAdmin() async {
    await Future.delayed(const Duration(seconds: 4), () {});
    Navigator.pushNamed(context, HomeScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkStatusAdmin());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'Cloth Store',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                  ],
                  isRepeatingAnimation: true,
                  onTap: () {
                    print("Tap Event");
                  },
                ),
              ),
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    'Admin Panel',
                    textStyle: colorizeTextStyle,
                    colors: colorizeColors,
                  ),
                ],
                isRepeatingAnimation: true,
                onTap: () {
                  print("Tap Event");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
