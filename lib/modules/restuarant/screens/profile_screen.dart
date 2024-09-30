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
  String  ? id;

  @override
  void initState() {
    super.initState();
    _fetchRestaurantDetails();
  }

  Future<void> _fetchRestaurantDetails() async {
    FirestoreService firestoreService = FirestoreService();

    FirebaseAuthService auth = FirebaseAuthService();

     id =  auth.getCurrentUser()?.uid;

    Map<String, dynamic>?  details = await firestoreService.getRestaurantById(id??'');

    // Assuming you want to show details of the first restaurant
    if (details != null ) {
      setState(() {
        restaurantDetails = details;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuthService().signOut();

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen(),), 
      (route) => false,);
  
    } catch (e) {
      print('Error signing out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('============');
    print(restaurantDetails?['imageUrl'] );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Restaurant Profile'),
        actions: [
          GestureDetector(
            onTap: () {

              Navigator.push(context, MaterialPageRoute(builder: (context) => EditScreen(restaurantId: id??'',),)).then((value) {
                _fetchRestaurantDetails();
              },);
              
            },
            child: const Icon(Icons.edit)),

              const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.logout,color: Colors.red,),
            onPressed: _logout,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: restaurantDetails == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Restaurant Details
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurantDetails?['name'] ?? 'Restaurant Name',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Phone Number: ${restaurantDetails?['phoneNumber'] ?? '(123) 456-7890'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Place: ${restaurantDetails?['place'] ?? '123 Elm Street, City, Country'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Email ID: ${restaurantDetails?['email'] ?? 'restaurant@example.com'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 32),
                      // Photos Section
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
                            Image.network(restaurantDetails?['imageUrl'] ?? 'https://via.placeholder.com/200', width: 200, fit: BoxFit.cover),
                            const SizedBox(width: 16),
                            // Add more images as needed or dynamically from data
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Google Maps Section
                      const Text(
                        'Restaurant Location',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      // Container(
                      //   height: 300,
                      //   child: GoogleMap(
                      //     initialCameraPosition: const CameraPosition(
                      //       target: LatLng(37.7749, -122.4194), // Replace with actual coordinates
                      //       zoom: 14.0,
                      //     ),
                      //     markers: {
                      //       Marker(
                      //         markerId: const MarkerId('restaurantMarker'),
                      //         position: LatLng(37.7749, -122.4194), // Replace with actual coordinates
                      //         infoWindow: InfoWindow(
                      //           title: restaurantDetails?['name'] ?? 'Restaurant Name',
                      //         ),
                      //       ),
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
