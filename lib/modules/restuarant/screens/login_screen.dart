

import 'package:flutter/material.dart';
import 'package:hungry/modules/restuarant/screens/bottomnavigation_screen.dart';
import 'package:hungry/modules/restuarant/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background Image
          Image.asset(
            'asset/images/images.jpg', // Replace with your image path
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
                  CircleAvatar(radius: 100,backgroundImage: AssetImage('asset/eyg.png'),),
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.lightGreen),
                  ),
                  const SizedBox(height: 32.0),
                  // Username Field
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color.fromARGB(179, 134, 10, 10), // Background color of the input field
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
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
                      fillColor: Color.fromARGB(179, 202, 190, 18), // Background color of the input field
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
                    onPressed: () {
                       Navigator.push(context, MaterialPageRoute(builder:(context) => BottomNavExample(),) );
                      if (_formKey.currentState?.validate() ?? false) {
                        final username = _usernameController.text;
                        final password = _passwordController.text;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Logging in with $username'),
                          ),
                        );
                        // Handle authentication logic here
                      }
                    },
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 16.0),
                  // Create Account Button
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context) => SignupScreen(),) );
                   
                    },
                    child: const Text('Create Account', style: TextStyle(color: Color.fromARGB(255, 224, 29, 166))),
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

