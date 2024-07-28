import 'package:fastrends/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedSplashScreen(
          splash: 'assets/images/Logo.png',
          splashIconSize: double.infinity,
          duration: 3000,
          nextScreen: MainApp(),
          backgroundColor: Colors.blue,
          splashTransition: SplashTransition.scaleTransition,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment(0.0, 0.6),
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 100,
            ),
          ),
        ),
      ],
    );
  }
}
