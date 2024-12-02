import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io'; // For working with files

class BannerServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads an image to Firebase Storage and returns the download URL.
  Future<String?> uploadImage(File image, BuildContext context) async {
    try {
      // Create a reference to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('banners').child(fileName);

      // Upload the image to Firebase Storage
      UploadTask uploadTask = ref.putFile(image);

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      // Show error message if the upload fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return null;
    }
  }

  /// Adds a banner to Firestore with the given data, including the image URL.
  Future<void> addBanner({
    required BuildContext context,
    required File imageFile,
    required String title,
    required String description, required bool isForOrphanage, required bool isForRestaurant,
  }) async {
    try {
      String? imageUrl = await uploadImage(imageFile, context);

      if (imageUrl != null) {
        // Define the data for the banner
        Map<String, dynamic> bannerData = {
          'imageUrl': imageUrl,
          'title': title,
          'description': description,
          'isforrestaurant':isForRestaurant,
          'isfororphanage':isForOrphanage,
          'createdAt': FieldValue.serverTimestamp(),
        };

        // Add the banner to Firestore under the 'banners' collection
        await _firestore.collection('banners').add(bannerData);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Banner added successfully!')),
        );
      }
    } catch (e) {
      // Show error message in case of an exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding banner: $e')),
      );
    }
  }

  /// Deletes a banner from Firestore using the banner's document ID.
  Future<void> deleteBanner({
    required BuildContext context,
    required String bannerId,
    required String imageUrl,
  }) async {
    try {
      // Delete the banner image from Firebase Storage
      await _storage.refFromURL(imageUrl).delete();

      // Delete the banner document from Firestore
      await _firestore.collection('banners').doc(bannerId).delete();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Banner deleted successfully!')),
      );
    } catch (e) {
      // Show error message in case of an exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting banner: $e')),
      );
    }
  }

  /// Fetches the list of banners as a stream of real-time updates from Firestore.
  Stream<QuerySnapshot> fetchBanners({
    required String field,
    required bool value,
  }) {
    return _firestore.collection('banners').where(field,isEqualTo: value).snapshots();
  }

  /// Updates a banner's details (title, description, and optionally image).
  Future<void> updateBanner({
    required BuildContext context,
    required String bannerId,
    String? newTitle,
    String? newDescription,
    File? newImageFile,
    String? oldImageUrl,
  }) async {
    try {
      String? imageUrl = oldImageUrl;

      // If a new image is provided, upload it and get the new URL.
      if (newImageFile != null) {
        imageUrl = await uploadImage(newImageFile, context);

        // Delete the old image from Firebase Storage
        if (oldImageUrl != null) {
          await _storage.refFromURL(oldImageUrl).delete();
        }
      }

      // Define the updated data for the banner
      Map<String, dynamic> updatedData = {
        'title': newTitle ?? '',
        'description': newDescription ?? '',
        if (imageUrl != null) 'imageUrl': imageUrl,
      };

      // Update the banner document in Firestore
      await _firestore.collection('banners').doc(bannerId).update(updatedData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Banner updated successfully!')),
      );
    } catch (e) {
      // Show error message in case of an exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating banner: $e')),
      );
    }
  }
}
