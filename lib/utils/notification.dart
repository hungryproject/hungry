import 'dart:convert';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

Future<void> handleBackGroundNotification(RemoteMessage message) async {
 
}

class FirebaseNotificatios {
  final messaging = FirebaseMessaging.instance;

  Future<String> getAdminToken() async {
    try {
      QuerySnapshot adminSnapshot = await FirebaseFirestore.instance
          .collection('admin')
          .where('email',
              isEqualTo: 'admin@gmail.com') // Replace with your condition
          .limit(1)
          .get();

      if (adminSnapshot.docs.isNotEmpty) {
        String token = adminSnapshot.docs[0].get('token');
        print(token);

        return token;
      } else {
        print('Admin document not found');
        return '';
      }
    } catch (error) {
      print('Error retrieving admin token: $error');
      return '';
    }
  }

  Future<String> getagriToken (String userId) async{

     try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('agriculture').doc(userId).get();

   
    if (documentSnapshot.exists) {
      
      Map<String, dynamic> userData = documentSnapshot.data() as Map<String, dynamic> ;
      

      String token  = userData['token'];

      return token;
      
    
     
    }else{
      return '';
    }
  } catch (e) {
     rethrow;
  }



  }

  Future<void> initNotification() async {
    await messaging.requestPermission();

    FirebaseMessaging.onBackgroundMessage(handleBackGroundNotification);
  }

  Future<void> sendNotificationToAdmin({String ? deviceToken,String ? body,String ? title}) async {
    const url = 'https://fcm.googleapis.com/fcm/send';
    const serverKey =
        'AAAAQyywLks:APA91bGBLpmAYofaH4uyU2jTrmMb8Dw6d786PGSh74UgD-RoPOKbCkqRBqk_P-4Kax0cLFmyHmWfseeoLSqWfm9Tkwc1JdTEfKdzSQdsws5fWa-xNu_n0IMpLkV89QNgaZ7HZcrPoOus'; // Replace with your FCM server key

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final message = {
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'status': 'done',
        'body': body,
        'title':  title,
      },
      "notification": <String, dynamic>{
        "title": title,
        "body":  body,
        "android_channel_id": "high_importance_channel"
      },
      'to': deviceToken,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Error: ${response.body}');
    }
  }
}