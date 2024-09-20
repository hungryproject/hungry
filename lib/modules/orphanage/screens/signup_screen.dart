import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  // Variable to store selected image
  File? _licensePhoto;

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // Function to pick image
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _licensePhoto = File(image.path);
      });
    }
  }

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
              SizedBox(height: 15),

            

              // Display selected image
              _licensePhoto != null
                  ? Image.file(
                      _licensePhoto!,
                      height: 150,
                    )
                  : Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(Icons.photo, size: 50),
                    ),
              SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.upload),
                label: Text('Upload License'),
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
