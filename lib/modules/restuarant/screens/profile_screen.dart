import 'package:flutter/material.dart';
import 'package:hungry/modules/restuarant/screens/edit_profile_screen.dart';
import 'package:hungry/modules/restuarant/screens/login_screen.dart';
import 'package:hungry/modules/restuarant/service/fire_store_serviece.dart';
import 'package:hungry/modules/restuarant/service/firebase_auth_services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? restaurantDetails;
  String? id;

  @override
  void initState() {
    super.initState();
    _fetchRestaurantDetails();
  }

  Future<void> _fetchRestaurantDetails() async {
    FirestoreService firestoreService = FirestoreService();
    FirebaseAuthService auth = FirebaseAuthService();

    id = auth.getCurrentUser()?.uid;

    Map<String, dynamic>? details = await firestoreService.getRestaurantById(id ?? '');

    if (details != null) {
      setState(() {
        restaurantDetails = details;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuthService().signOut();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Restaurant Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditScreen(
                    restaurantId: id ?? '',
                  ),
                ),
              ).then((value) {
                _fetchRestaurantDetails();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: _logout,
          ),
        ],
      ),
      body: restaurantDetails == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCard(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.restaurant, size: 30, color: Colors.orange),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                restaurantDetails?['name'] ?? 'Restaurant Name',
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        _buildDetailRow(Icons.phone, 'Phone', restaurantDetails?['phoneNumber'] ?? '(123) 456-7890'),
                        const SizedBox(height: 8),
                        _buildDetailRow(Icons.location_on, 'Place', restaurantDetails?['place'] ?? '123 Elm Street, City, Country'),
                        const SizedBox(height: 8),
                        _buildDetailRow(Icons.email, 'Email', restaurantDetails?['email'] ?? 'restaurant@example.com'),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditScreen(
                                  restaurantId: id ?? '',
                                ),
                              ),
                            ).then((value) {
                              _fetchRestaurantDetails();
                            });
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Profile'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildCard(
                      children: [
                        const Text(
                          'Restaurant Photos',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  restaurantDetails?['imageUrl'] ?? 'https://via.placeholder.com/200',
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                   
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 10),
        Text(
          '$label: $value',
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
