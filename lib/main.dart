import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hungry/firebase_options.dart';
import 'package:hungry/modules/choose_screen.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();

   

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily:"hungryfont" ,
      
    ),
    home:const ChooseScreen(),),);
  }
 