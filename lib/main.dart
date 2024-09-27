import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hungry/firebase_options.dart';
import 'package:hungry/modules/admin/screen/adminhome_screen.dart';
import 'package:hungry/modules/admin/screen/admprof_screen.dart';
import 'package:hungry/modules/admin/screen/vieworph_screen.dart';
import 'package:hungry/modules/admin/screen/viewrest_screen.dart';
import 'package:hungry/modules/orphanage/screens/bottommnavigation_screen.dart';
import 'package:hungry/modules/orphanage/screens/signup_screen.dart';
import 'package:hungry/modules/restuarant/screens/bottomnavigation_screen.dart';
import 'package:hungry/modules/restuarant/screens/login_screen.dart';
import 'package:hungry/modules/restuarant/screens/order_screen.dart';
import 'package:hungry/modules/restuarant/screens/signup_screen.dart';


Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();

   

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily:"hungryfont" ,
      
    ),
    home:AdminPage(),),);
  }
 