import 'package:flutter/material.dart';

class OrphanageLoginPage extends StatefulWidget {
  @override
  _OrphanageLoginPageState createState() => _OrphanageLoginPageState();
}

class _OrphanageLoginPageState extends State<OrphanageLoginPage> {
  // Controllers to get text input
  final TextEditingController orphanageNameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              // Orphanage Name
              TextField(
                controller: orphanageNameController,
                decoration: InputDecoration(
                  labelText: 'Orphanage Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              
              // Place
              TextField(
                controller: placeController,
                decoration: InputDecoration(
                  labelText: 'Place',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              
              // Number
              TextField(
                controller: numberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              
              // Email ID
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email ID',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              
              // Password
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              
              // Confirm Password
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              
              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your login logic here
                  },
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}