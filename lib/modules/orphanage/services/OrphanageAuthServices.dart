import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hungry/utils/helper.dart';

class OrphanageAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = FireStorageService();

  // Register and add orphanage data to Firestore
  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String orphanageName,
    required String place,
    required String phoneNumber,
    required File licensePhotoUrl, required String numberOfPeople,
  }) async {
    try {
      // Register user with Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Save orphanage details to Firestore with UID as document ID
        var url = await storage.uploadImage(licensePhotoUrl);
        await _firestore.collection('orphanages').doc(user.uid).set({
          'orphanageName': orphanageName,
          'place': place,
          'phoneNumber': phoneNumber,
          'email': email,
          'isAccepted' : false,
          'licensePhotoUrl': url, // Add image URL
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      } else {
        throw Exception(e.message ?? 'An error occurred during registration.');
      }
    } catch (e) {
      throw Exception('An unknown error occurred during registration: $e');
    }
  }

  // Login user and check if they're registered as an orphanage

  Future<User?> signInWithEmailAndPassword({
  required String email,
  required String password,
}) async {
  try {
    // Sign in the user with Firebase Authentication
    UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;

    if (user != null) {
      // Check if the user exists in the orphanages Firestore collection
      DocumentSnapshot orphanageSnapshot =
          await _firestore.collection('orphanages').doc(user.uid).get();

      if (orphanageSnapshot.exists) {
        // Check if the orphanage is accepted
        bool isAccepted = orphanageSnapshot['isAccepted'] ?? false;

        if (isAccepted) {
          // Orphanage is accepted, allow login
          return user;
        } else {
          // Orphanage is not yet accepted, sign out the user and throw an error
          await _auth.signOut();
          throw Exception('Your account has not been accepted yet. Please wait for approval.');
        }
      } else {
        // User not found in orphanage collection, sign them out and throw an error
        await _auth.signOut();
        throw Exception('Orphanage not registered. Please sign up first.');
      }
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      throw Exception('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      throw Exception('Wrong password provided for that user.');
    } else {
      throw Exception(e.message ?? 'An error occurred during login.');
    }
  } catch (e) {
    throw Exception('An unknown error occurred during login: $e');
  }
  return null; // Return null if login fails
}


  // Get UID of the current user
  String getId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }
}
