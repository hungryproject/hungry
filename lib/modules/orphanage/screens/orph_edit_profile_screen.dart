import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hungry/modules/restuarant/service/firestorage_serviece.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditOrphanageDetailsScreen extends StatefulWidget {
  @override
  _EditOrphanageDetailsScreenState createState() =>
      _EditOrphanageDetailsScreenState();
}

class _EditOrphanageDetailsScreenState
    extends State<EditOrphanageDetailsScreen> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _membersController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  File? _image;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadOrphanageDetails();
  }

  Future<void> _loadOrphanageDetails() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final docSnapshot = await FirebaseFirestore.instance
        .collection('orphanages')
        .doc(userId)
        .get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      _nameController.text = data['orphanageName'] ?? '';
      _locationController.text = data['place'] ?? '';
      _emailController.text = data['email'] ?? '';
      _phoneController.text = data['phoneNumber'] ?? '';
      _membersController.text = data['members']?.toString() ?? '';
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      final orphanageRef =
          FirebaseFirestore.instance.collection('orphanages').doc(userId);

      String? imageUrl;
      if (_image != null) {
         imageUrl = await StorageService().uploadImage(_image!);
        
      }

      await orphanageRef.update({
        'orphanageName': _nameController.text,
        'place': _locationController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneController.text,
        'members': int.tryParse(_membersController.text) ?? 0,

        if (imageUrl != null) 'licensePhotoUrl': imageUrl,
      });

      if (_passwordController.text.isNotEmpty) {
        await FirebaseAuth.instance.currentUser
            ?.updatePassword(_passwordController.text);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Orphanage details updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Orphanage Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Orphanage Name'),
                  ),
                  const Divider(),
                  TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                  ),
                  const Divider(),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email ID'),
                  ),
                  const Divider(),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                  ),
                  const Divider(),
                  TextField(
                    controller: _membersController,
                    decoration: const InputDecoration(labelText: 'Number of Members'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16.0),
                  if (_image != null)
                    Image.file(
                      _image!,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  if (_image == null)
                    const Text('No image selected'),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Select Image'),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
