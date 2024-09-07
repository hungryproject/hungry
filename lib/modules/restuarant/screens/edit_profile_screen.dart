import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import '../service/fire_store_serviece.dart';
import '../service/firestorage_serviece.dart';
import '../service/firebase_auth_services.dart'; // Import the auth service

class EditScreen extends StatefulWidget {
  final String restaurantId; // ID of the restaurant to edit

  const EditScreen({required this.restaurantId, super.key});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final FirestoreService _firestoreService = FirestoreService(); // FirestoreService instance
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  final TextEditingController _restaurantNameController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? oldPassword;
  String ? oldemail;
  String? _existingImageUrl; // Add field for the existing image URL

  bool _isLoading = false;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _fetchRestaurantDetails();
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _restaurantNameController.dispose();
    _placeController.dispose();
    _numberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Fetch current restaurant details and populate the controllers
  Future<void> _fetchRestaurantDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var restaurant = await _firestoreService.getRestaurantById(widget.restaurantId);
      if (restaurant != null) {
        _restaurantNameController.text = restaurant['name'] ?? '';
        _placeController.text = restaurant['place'] ?? '';
        _numberController.text = restaurant['phoneNumber'] ?? '';
        _emailController.text = restaurant['email'] ?? '';
        oldemail = restaurant['email'] ??'';
        oldPassword = restaurant['password'];
        _existingImageUrl = restaurant['imageUrl']; // Fetch existing image URL
      } else {
        // Handle the case where the restaurant is not found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restaurant not found.')),
        );
      }
    } catch (e) {
      print('Error fetching restaurant details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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

  // Method to upload image and handle update
  Future<void> _uploadImageAndUpdate() async {
    if (_selectedImage == null && _existingImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {

      if(oldemail != _emailController.text.trim()){

        _updateEmail(_emailController.text.trim(), oldPassword!);


      }

      if(_confirmPasswordController.text.isNotEmpty){
        if(_confirmPasswordController.text != oldPassword){

      _updatepassword();


      }
      }
     
   

      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await StorageService().uploadImage(_selectedImage!);
      } else {
        imageUrl = _existingImageUrl;
      }

      await _firestoreService.updateRestaurant(
        name: _restaurantNameController.text.trim(),
        place: _placeController.text.trim(),
        phoneNumber: _numberController.text.trim(),
        email: _emailController.text,
        id: widget.restaurantId,
        imageUrl: imageUrl!,
      );

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Update successful!')),
      );
      
    } catch (e) {
      print('Error during update: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to update email and password only
  Future<void> _updateEmail(String email,String oldPassword) async {
  
    

  
      try {
        await FirebaseAuthService().updateEmail(email, oldPassword);
        

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email  updated successfully!')),
        );
      } catch (e) {
        print('Error updating email and password: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    
  }

  // Method to update email and password only
  Future<void> _updatepassword() async {
   
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (password == confirmPassword) {
      try {
        await FirebaseAuthService().updatePassword(password, oldPassword!);
        

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email  updated successfully!')),
        );
      } catch (e) {
        print('Error updating email and password: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
    }
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "EDIT RESTAURANT",
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
                )
              else if (_existingImageUrl != null)
                Image.network(
                  _existingImageUrl!,
                  height: 150.0,
                  width: 150.0,
                  fit: BoxFit.cover,
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Upload Image'),
                ),
              ),
              CustomTextField(
                controller: _restaurantNameController,
                labelText: 'Restaurant Name',
              ),
              CustomTextField(
                controller: _placeController,
                labelText: 'Place',
              ),
              CustomTextField(
                controller: _numberController,
                labelText: 'Number',
                keyboardType: TextInputType.phone,
              ),

              CustomTextField(
                      controller: _emailController,
                      labelText: 'Email ID',
                      keyboardType: TextInputType.emailAddress,
                    ),
              
              CustomTextField(
                controller: _passwordController,
                labelText: 'New Password',
                obscureText: true,
              ),

              CustomTextField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      obscureText: true,
                    ),
            
             
             
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _uploadImageAndUpdate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text('Update Restaurant'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}




class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;

  const CustomTextField({
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
      ),
    );
  }
}
