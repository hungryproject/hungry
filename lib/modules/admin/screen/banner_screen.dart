import 'package:flutter/material.dart';
import 'package:hungry/modules/admin/services/banner_services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BannerAdPage extends StatefulWidget {
  const BannerAdPage({super.key});

  @override
  _BannerAdPageState createState() => _BannerAdPageState();
}

class _BannerAdPageState extends State<BannerAdPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool loading = false;

  // Toggle states
  bool _isForOrphanage = false;
  bool _isForRestaurant = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submitForm() async {
    setState(() {
      loading = true;
    });

    final String name = _nameController.text;
    final String description = _descriptionController.text;

    if (_imageFile == null || name.isEmpty || description.isEmpty || (!_isForOrphanage && !_isForRestaurant)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please provide all required details and select a category.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      setState(() {
        loading = false;
      });
      return;
    }

    await BannerServices().addBanner(
      context: context,
      imageFile: _imageFile!,
      title: name,
      description: description,
      isForOrphanage: _isForOrphanage,
      isForRestaurant: _isForRestaurant,
    );

    _imageFile = null;
    _nameController.clear();
    _descriptionController.clear();
    

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: loading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Add Banner Ad',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Banner Name',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter banner name',
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Description',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _descriptionController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter description',
                                    ),
                                    maxLines: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _imageFile == null
                              ? GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: const Center(
                                      child: Text('Tap to Upload Image', style: TextStyle(color: Colors.black54)),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: _pickImage,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Image.file(
                                      _imageFile!,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 16),
                          const Text(
                            'Select Category',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8.0,
                            children: [
                              ChoiceChip(
                                label: const Text('Orphanage'),
                                selected: _isForOrphanage,
                                onSelected: (selected) {
                                  setState(() {
                                    _isForOrphanage = selected;
                                    if (selected) {
                                      _isForRestaurant = false;
                                    }
                                  });
                                },
                                selectedColor: Colors.greenAccent,
                              ),
                              ChoiceChip(
                                label: const Text('Restaurant'),
                                selected: _isForRestaurant,
                                onSelected: (selected) {
                                  setState(() {
                                    _isForRestaurant = selected;
                                    if (selected) {
                                      _isForOrphanage = false;
                                    }
                                  });
                                },
                                selectedColor: Colors.greenAccent,
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: const Text(
                                    'Submit Banner',
                                    style: TextStyle(fontSize: 18, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
