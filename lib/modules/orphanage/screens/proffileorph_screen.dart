import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hungry/modules/choose_screen.dart';
import 'package:hungry/modules/orphanage/screens/orph_edit_profile_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileOrphanage extends StatefulWidget {
  const ProfileOrphanage({super.key});

  @override
  State<ProfileOrphanage> createState() => _ProfileOrphanageState();
}

class _ProfileOrphanageState extends State<ProfileOrphanage> {
  Future<Map<String, dynamic>?> _getOrphanageDetails() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return null;

    final docSnapshot = await FirebaseFirestore.instance
        .collection('orphanages')
        .doc(userId)
        .get();

    return docSnapshot.data();
  }

  Future _editOrphanageDetails(BuildContext context) async{
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditOrphanageDetailsScreen(),
      ),
    ).then((value) {

      setState(() {});
      
    },);
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ChooseScreen()), (route) => false);
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Color.fromARGB(177, 1, 170, 153)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orphanage Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) async {
              if (value == 'edit') {
                await _editOrphanageDetails(context);
              } else if (value == 'logout') {
                _confirmLogout(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit Details'),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: Text('Log Out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getOrphanageDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Failed to load orphanage details.'));
          }

          final data = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['orphanageName'] ?? 'Unknown Orphanage',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const Divider(),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.red),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  data['place'] ?? 'Unknown Location',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              const Icon(Icons.email, color: Colors.blue),
                              const SizedBox(width: 8.0),
                              Text(
                                data['email'] ?? 'No Email',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              const Icon(Icons.phone, color: Colors.green),
                              const SizedBox(width: 8.0),
                              Text(
                                data['phoneNumber'] ?? 'No Phone',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              const Icon(Icons.group, color: Colors.purple),
                              const SizedBox(width: 8.0),
                              Text(
                                'Number of Members: ${data['members'] ?? 'N/A'}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: ()async => await _editOrphanageDetails(context),
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit Details'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: const Color.fromARGB(255, 11, 169, 172),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _confirmLogout(context),
                              icon: const Icon(Icons.logout),
                              label: const Text('Log Out'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: const Color.fromARGB(255, 11, 169, 172),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (data['licensePhotoUrl'] != null)
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'License Photo:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Image.network(
                              data['licensePhotoUrl'],
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Edit Orphanage Details Page
