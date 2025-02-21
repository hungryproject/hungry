import 'package:flutter/material.dart';
// Import for User type
import 'package:hungry/modules/admin/screen/adminhome_screen.dart';
import 'package:hungry/modules/admin/services/admin_auth_service.dart';
import 'package:lottie/lottie.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _authService = Adminauthservices();
  bool _isLoading = false; // State to track loading status

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      final email = _usernameController.text;
      final password = _passwordController.text;

      try {
        bool? user =
            await _authService.signInWithEmailAndPassword(email, password);

        setState(() {
          _isLoading = false; // Hide loading indicator
        });

        if (user) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminPage()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Welcome'),
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
      backgroundColor: const Color.fromARGB(255, 150, 198, 192),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Login Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 130,
                    child: Lottie.asset(
                      'asset/Animation - 1740118815659.json', // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                      fillColor: Color.fromARGB(255, 249, 251, 251),
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
                      fillColor: Color.fromARGB(255, 239, 240, 239),
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
                    onPressed:
                        _isLoading ? null : _login, // Disable button if loading
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(136, 14, 133, 103),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white), // Loading indicator color
                          )
                        : const Text('Login', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}