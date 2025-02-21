import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hungry/modules/restuarant/screens/bottomnavigation_screen.dart';
import 'package:hungry/modules/restuarant/screens/signup_screen.dart';
import 'package:hungry/utils/helper.dart';
import 'package:lottie/lottie.dart';
import '../service/firebase_auth_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  bool _isLoading = false; // State to track loading status

  // Animation controller for fade and scale animations
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  Future<void> _login() async {
    print('hhhh');
    if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      print('hhhh');
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      final email = _usernameController.text;
      final password = _passwordController.text;

      try {
        User? user = await _authService.signInWithEmailAndPassword(email, password);

        print('hi');

        await Helper().sendNotificationToDevice(
            'dcc7b081-eae7-4ca3-b3b0-d90fc57a2ef5', 'title', 'body');

        setState(() {
          _isLoading = false; // Hide loading indicator
        });

        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RestaurantRootScreen()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome, ${user.email}'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login failed. Please check your credentials.'),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose of animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 250, 240, 215), // Light, warm background color (restaurant theme)
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Login Form with Animation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Animated Logo with Scale Effect (like a restaurant icon)
                  CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 130,
                      child: Lottie.asset(
                        'asset/Animation - 1740117667865.json',
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 24.0),
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 59, 100, 12), // Restaurant-themed green
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  // Username Field with Slide Animation
                  SlideTransition(
                    position: _slideAnimation,
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Color.fromARGB(255, 67, 122, 42)), // Restaurant green
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Color.fromARGB(179, 56, 189, 98), // Light green background
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 56, 189, 98)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Password Field with Slide Animation
                  SlideTransition(
                    position: _slideAnimation,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Color.fromARGB(255, 67, 122, 42)), // Restaurant green
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Color.fromARGB(179, 66, 167, 60), // Dark green background
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 66, 167, 60)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  // Login Button with Fade Animation
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login, // Disable button if loading
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 56, 189, 98), // Restaurant green
                        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 60.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text('Login', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Create Account Button with Slide Animation
                  SlideTransition(
                    position: _slideAnimation,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignupScreen()),
                        );
                      },
                      child: const Text(
                        'Create Account',
                        style: TextStyle(color: Color.fromARGB(255, 56, 175, 67)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
