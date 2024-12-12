import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hungry/firebase_options.dart';
import 'package:hungry/modules/choose_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
   

  
  
  OneSignal.initialize("b02d5964-ada6-46b6-9d9e-6487a3a6ecae");
  await OneSignal.Notifications.requestPermission(true);
  var external = await OneSignal.User.getOnesignalId();
 

  OneSignal.User.addTagWithKey('userId', external);

  

  final a = await OneSignal.User.getTags();;
  print(a['userId']);


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily:"hungryfont" ,
      
    ),
    home:const ChooseScreen(),),);
  }
 