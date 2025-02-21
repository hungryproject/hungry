import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:hungry/modules/choose_screen.dart'; // Update with your actual next screen

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
    await Future.delayed(const Duration(seconds: 3)); // Duration before navigation
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChooseScreen()), // Change to your actual home screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal, // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/food.json', // Replace with your animation file
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              'Hungry App',
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
