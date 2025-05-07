import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:my_shop/screens/onBoardingScreen.dart';
import 'package:my_shop/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Start fade-in animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Navigate to OnboardingScreen after 3 seconds
    Timer(
      const Duration(seconds: 3),
      () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  Onboardingscreen()),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              AppColors.lavenderPurple.withOpacity(0.7),
            ],
          ),
          image: const DecorationImage(
            image: AssetImage("images/image.png"),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(size),
            SizedBox(height: size.height * 0.03),
            _buildAppName(),
          ],
        ),
      ),
    );
  }

  // Widget for the circular logo with shopping cart icon
  Widget _buildLogo(Size size) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 1000),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.softPink.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 3,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: EdgeInsets.all(size.width * 0.08),
        child: Icon(
          Icons.shopping_cart,
          size: size.width * 0.2,
          color: AppColors.lavenderPurple,
        ),
      ),
    );
  }

  // Widget for the "Shop Up" text with stroke effect
  Widget _buildAppName() {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 1200),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            "Shop Up",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.1,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              letterSpacing: 1.5,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1.5
                ..color = Colors.black.withOpacity(0.8),
            ),
          ),
          Text(
            "Shop Up",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.1,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              letterSpacing: 1.5,
              color: AppColors.lavenderPurple,
              shadows: [
                Shadow(
                  color: AppColors.softPink.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}