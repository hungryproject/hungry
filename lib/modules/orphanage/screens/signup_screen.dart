import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hungry/modules/orphanage/services/OrphanageAuthServices.dart';
import 'package:image_picker/image_picker.dart';

class OrphanageLoginPage extends StatefulWidget {
  const OrphanageLoginPage({super.key});

  @override
  State<OrphanageLoginPage> createState() => _OrphanageLoginPageState();
}

class _OrphanageLoginPageState extends State<OrphanageLoginPage> {
  // Controllers to get text input
  final TextEditingController orphanageNameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController peopleController = TextEditingController(); // New controller for number of people
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Variable to store selected image
  File? _licensePhoto;

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // Loading state
  bool isLoading = false;

  // Function to pick image
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _licensePhoto = File(image.path);
      });
    }
  }

  void registerHandler() async {
    if (_licensePhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a license photo')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await OrphanageAuthServices().registerWithEmailAndPassword(
        email: emailController.text,
        password: confirmPasswordController.text,
        orphanageName: orphanageNameController.text,
        place: placeController.text,
        phoneNumber: numberController.text,
        licensePhotoUrl: _licensePhoto!,
        numberOfPeople: peopleController.text, // Pass the number of people
      );

      Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
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
              const Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Orphanage Name
              TextField(
                controller: orphanageNameController,
                decoration: const InputDecoration(
                  labelText: 'Orphanage Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // Place
              TextField(
                controller: placeController,
                decoration: const InputDecoration(
                  labelText: 'Place',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // Number
              TextField(
                controller: numberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // Number of People
              TextField(
                controller: peopleController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of People',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // Email ID
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // Password
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // Confirm Password
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

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
                      child: const Icon(Icons.photo, size: 50),
                    ),
              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.upload),
                label: const Text('Upload License'),
              ),
              const SizedBox(height: 30),

              // Signup Button with loading state
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null // Disable button when loading
                      : () {
                          registerHandler();
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Signup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
