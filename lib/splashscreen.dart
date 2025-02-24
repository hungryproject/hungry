import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:hungry/modules/choose_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChooseScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              'asset/Animation - 1740392320240 (1).json',
              height: 480,
              width: 400,
              fit: BoxFit.contain,
              repeat: true, // Ensures smooth looping
              alignment: Alignment.center,
              reverse: false,
              animate: true,
            ),
            const SizedBox(height: 20),
            const Text(
              'Hungry',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
