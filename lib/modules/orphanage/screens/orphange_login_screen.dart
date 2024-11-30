import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for User type
import 'package:hungry/modules/orphanage/screens/bottommnavigation_screen.dart';
import 'package:hungry/modules/orphanage/screens/signup_screen.dart';
import 'package:hungry/modules/orphanage/services/OrphanageAuthServices.dart';
import 'package:hungry/modules/restuarant/screens/bottomnavigation_screen.dart';
import 'package:hungry/modules/restuarant/screens/signup_screen.dart';
import 'package:lottie/lottie.dart';
import '../../restuarant/service/firebase_auth_services.dart';

class OrphanageLoginScreen extends StatefulWidget {
  const OrphanageLoginScreen({super.key});

  @override
  _OrphanageLoginScreenState createState() => _OrphanageLoginScreenState();
}

class _OrphanageLoginScreenState extends State<OrphanageLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final OrphanageAuthServices _authService = OrphanageAuthServices(); // Use OrphanageAuthServices
  bool _isLoading = false; // State to track loading status

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      try {
        // Sign in using Firebase Authentication
        User? user = await _authService.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        print(_emailController.text.trim());
        print( _passwordController.text.trim());

        if (user != null) {
          // Navigate to the home screen after successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const OrphnageRootScreen(), // Replace with your target screen
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Failed to sign in')),
        );
      } catch(e){

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString() ?? 'Failed to sign in')),
        );

      }
      finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background Image
          Lottie.asset(
            'asset/Animation - 1728213854723.json', // Replace with your image path
            fit: BoxFit.cover,
          ),
          // Login Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 80,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('asset/orphans.png'),
                    ),
                  ),
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 59, 100, 12),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color.fromARGB(179, 240, 74, 8),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color.fromARGB(179, 220, 64, 11),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32.0),
                  // Login Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login, // Disable button if loading
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Loading indicator color
                          )
                        : const Text('Login'),
                  ),
                  const SizedBox(height: 16.0),
                  // Create Account Button
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  OrphanageLoginPage()), // Adjust to the correct screen
                      );
                    },
                    child: const Text(
                      'Create Account',
                      style: TextStyle(color: Color.fromARGB(255, 56, 175, 67)),
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
