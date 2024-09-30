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

  bool  loading =  false;

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Function to submit the form
  void _submitForm() async {


    setState(() {
      loading = true;
    });
    final String name = _nameController.text;
    final String description = _descriptionController.text;

    if (_imageFile == null || name.isEmpty || description.isEmpty) {
      // Show an alert if the fields are empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please provide all the required details.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

      setState(() {
        loading = false;
      });
    } else {

      
     await  BannerServices().addBanner(context: context, imageFile: _imageFile!, title: name, description: description);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Banner Ad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: loading ?  const Center(child: CircularProgressIndicator(),)  : SingleChildScrollView(
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
              const SizedBox(height: 16),
              const Text(
                'Banner Image',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _imageFile == null
                  ? Container(
                      height: 150,
                      width: double.infinity,
                      color: const Color.fromARGB(255, 236, 219, 219),
                      child: const Center(
                        child: Text('No Image Selected'),
                      ),
                    )
                  : Image.file(
                      _imageFile!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.add_a_photo),
                label: const Text('Upload Image'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  backgroundColor: const Color.fromARGB(255, 241, 227, 243),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Gradient Button
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color.fromARGB(255, 220, 9, 9), Color.fromARGB(255, 134, 127, 136)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      'Submit Banner',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),


           
           
           
            ],
          ),
        ),
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
