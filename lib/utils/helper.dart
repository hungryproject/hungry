import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class FireStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('restaurant_images').child(fileName);
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}


class Helper{

  final _firebase = FirebaseFirestore.instance;


  Future<void> addtoken({
    required String id,
    required String collectionName
  })async{

    String ? token = await OneSignal.User.getOnesignalId();
    print(token);
    _firebase.collection(collectionName).doc(id).update(
            {
              'token': token
            }
          );
  }




  
Future<void> sendNotificationToDevice(String playerId, String title, String body) async {
  const String oneSignalRestApiKey = 'ZDRiMGNmZDUtMjAwZS00NDIzLWFjNDEtNmVmYjY0ZDMwMDA3';
  const String oneSignalAppId = 'b02d5964-ada6-46b6-9d9e-6487a3a6ecae';

  var url = Uri.parse('https://onesignal.com/api/v1/notifications');

  var notificationData = {
    "app_id": oneSignalAppId,
    "headings": {"en": title},
    "contents": {"en": body},
  };

  var headers = {
    "Content-Type": "application/json; charset=utf-8",
    "Authorization": "Basic $oneSignalRestApiKey",
  };

  try {
    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(notificationData),
    );

    if (response.statusCode == 200) {
      print("Notification Sent Successfully!");
      print(response.body);
    } else {
      print("Failed to send notification: ${response.statusCode}");
    }
  } catch (e) {
    print("Error sending notification: $e");
  }
}



}
