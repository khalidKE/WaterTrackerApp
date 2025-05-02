import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker/screens/onboard.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "images/small_glass.png",
                    fit: BoxFit.cover,
                    color: Colors.white.withOpacity(0.2),
                    colorBlendMode: BlendMode.overlay,
                  ).animate().fadeIn(duration: 1000.ms),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 24.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome to Water Tracker 💧",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Quicksand',
                          ),
                        ).animate().slideX(
                          duration: 800.ms,
                          begin: -0.5,
                          end: 0,
                          curve: Curves.easeOut,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "Stay Hydrated Every Day",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Quicksand',
                          ),
                        ).animate().slideX(
                          duration: 800.ms,
                          delay: 200.ms,
                          begin: -0.5,
                          end: 0,
                          curve: Curves.easeOut,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "Track your water intake and build healthy hydration habits!",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Quicksand',
                          ),
                        ).animate().fadeIn(duration: 800.ms, delay: 400.ms),
                        SizedBox(height: 80.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
