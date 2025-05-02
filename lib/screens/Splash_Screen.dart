import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:water_tracker/screens/intro.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: LottieBuilder.asset('images/splash.json'),
        nextScreen:
            
                   const IntroductionScreen(),
                ));
       
}}
