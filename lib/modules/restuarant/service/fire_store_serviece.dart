import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hungry/modules/restuarant/service/firebase_auth_services.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  // Method to add a restaurant
  Future<void> addRestaurant({
    required String name,
    required String place,
    required String phoneNumber,
    required String email,
    required String password,
    required String id,
    required String imageUrl, // New parameter for image URL
  }) async {
    try {
      await _firestore.collection('restaurants').doc(id).set({
        'name': name,
        'place': place,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': password,
        'imageUrl': imageUrl, // Save the image URL
      });
    } catch (e) {
      print('Error adding restaurant: $e');
      // Handle errors (e.g., show a SnackBar with an error message)
      throw Exception('Failed to add restaurant: $e');
    }
  }

  // Method to get restaurant details by ID
  Future<Map<String, dynamic>?> getRestaurantById(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('restaurants').doc(id).get();

      if (doc.exists) {
        return {
          'id': doc.id, // Document ID for reference
          ...doc.data() as Map<String, dynamic>, // Cast data to Map
        };
      } else {
        print('Restaurant not found.');
        return null;
      }
    } catch (e) {
      print('Error getting restaurant details: $e');
      // Handle errors (e.g., show a SnackBar or return null)
      throw Exception('Failed to get restaurant details: $e');
    }
  }

  // Method to update a restaurant
  Future<void> updateRestaurant({
    required String id,
    String? name,
    String? place,
    String? phoneNumber,
    String? email,
    String? password,
    String? imageUrl,
  }) async {
    try {
      final Map<String, dynamic> updateData = {};

      if (name != null) updateData['name'] = name;
      if (place != null) updateData['place'] = place;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (email != null) updateData['email'] = email;
      // if (password != null) updateData['password'] = password;
      if (imageUrl != null) updateData['imageUrl'] = imageUrl;

      if (updateData.isNotEmpty) {
        await _firestore.collection('restaurants').doc(id).update(updateData);
      } else {
        print('No data to update.');
      }
    } catch (e) {
      print('Error updating restaurant: $e');
      // Handle errors (e.g., show a SnackBar with an error message)
      throw Exception('Failed to update restaurant: $e');
    }
  }

  // Method to add an order
  Future<void> addfood({
    required String foodName,
    required int quantity,
    required String availableUntil,
    required bool isDelivered,
    required bool isOrderAccepted,
  }) async {
    try {
      User? user = _firebaseAuthService.getCurrentUser();

      if (user != null) {
        await _firestore.collection('foods').add({
          'foodName': foodName,
          'quantity': quantity,
          'resid': user.uid,
          'availableUntil': availableUntil, // Storing date as a string
          'isDelivered': isDelivered,
          'isOrderAccepted': isOrderAccepted,
          'createdAt':
              FieldValue.serverTimestamp(), // Optional: To track when the order was created
        });
      }
      print('Order added successfully');
    } catch (e) {
      print('Error adding order: $e');
      throw Exception('Failed to add order: $e');
    }
  }

  // Stream to get all orders where isOrderAccepted is false and resid matches current user
  Stream<QuerySnapshot> getPendingOrders() {
    User? user = _firebaseAuthService.getCurrentUser();
    if (user == null) {
      throw Exception('No user logged in');
    }
    return _firestore
        .collection('foods')
        .where('isOrderAccepted', isEqualTo: false)
        .where('resid', isEqualTo: user.uid).snapshots();
  }
}
