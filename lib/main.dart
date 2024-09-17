import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hungry/firebase_options.dart';
import 'package:hungry/modules/orphanage/screens/bottommnavigation_screen.dart';
import 'package:hungry/modules/orphanage/screens/noti_screen.dart';
import 'package:hungry/modules/orphanage/screens/signup_screen.dart';
import 'package:hungry/modules/restuarant/screens/login_screen.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();

   

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    theme: ThemeData(fontFamily:"hungryfont" ,
      
    ),
    home:OrphnageRootScreen(),));
  }
 