import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for User type
import 'package:hungry/modules/restuarant/screens/bottomnavigation_screen.dart';
import 'package:hungry/modules/restuarant/screens/signup_screen.dart';
import '../service/firebase_auth_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  bool _isLoading = false; // State to track loading status

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      final email = _usernameController.text;
      final password = _passwordController.text;

      try {
        User? user = await _authService.signInWithEmailAndPassword(email, password);
        
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background Image
          Image.asset(
            'asset/images/jhgf.jpg', // Replace with your image path
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
                    radius: 100,
                    backgroundImage: AssetImage('asset/images/restu.jpg'),
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
                  // Username Field
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color.fromARGB(179, 56, 189, 98),
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
                      fillColor: Color.fromARGB(179, 66, 167, 60),
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
                        MaterialPageRoute(builder: (context) => const SignupScreen()),
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
