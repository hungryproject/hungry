import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hungry/modules/restuarant/service/firestorage_serviece.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import '../service/fire_store_serviece.dart';
import '../service/firebase_auth_services.dart'; // Import the auth service
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService(); // FirestoreService instance

  final TextEditingController _restaurantNameController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _restaurantNameController.dispose();
    _placeController.dispose();
    _numberController.dispose();
    _licenseController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Method to pick an image
  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  // Method to upload image and handle signup

  Future<void> _uploadImageAndSignup() async {
  if (_selectedImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select an image.')),
    );
    return;
  }

  setState(() {
    _isLoading = true; 
  });

  try {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (password == confirmPassword) {
      var user = await _authService.registerWithEmailAndPassword(email, password);

      if (user != null) {
        String? imageUrl = await StorageService().uploadImage(_selectedImage!);

        await _firestoreService.addRestaurant(
          name: _restaurantNameController.text.trim(),
          place: _placeController.text.trim(),
          phoneNumber: _numberController.text.trim(),
          email: email,
          password: password,
          id: user.uid,
          imageUrl: imageUrl!, 
        );

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup failed. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
    }
  } catch (e) {
    // Catch any errors that occur during the process
    print('Error during signup: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $e')),
    );
  } finally {
    setState(() {
      _isLoading = false; // Stop the loading indicator
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SIGN UP",
          style: TextStyle(
            color: Colors.red,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_selectedImage != null)
                Image.file(
                  _selectedImage!,
                  height: 150.0,
                  width: 150.0,
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Upload License'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: _restaurantNameController,
                  decoration: const InputDecoration(
                    labelText: 'Restaurant Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: _placeController,
                  decoration: const InputDecoration(
                    labelText: 'Place',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: _numberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Number',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email ID',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              _isLoading
                  ? const Center(child: CircularProgressIndicator()) // Show loading indicator
                  : ElevatedButton(
                      onPressed: _uploadImageAndSignup, // Update onPressed function
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: const Text('Submit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
