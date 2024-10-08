// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAF_40j_h4WH3SA7D3MwRcFZkHK1OO83SA',
    appId: '1:552418255511:web:05b979b47dabd0d133ffd2',
    messagingSenderId: '552418255511',
    projectId: 'hungry-b1926',
    authDomain: 'hungry-b1926.firebaseapp.com',
    storageBucket: 'hungry-b1926.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDiIGu1_X2b-HQIC7GXJxRWGU9T261dA3U',
    appId: '1:552418255511:android:e0a8d8fd3ed0157b33ffd2',
    messagingSenderId: '552418255511',
    projectId: 'hungry-b1926',
    storageBucket: 'hungry-b1926.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCxXlyhQHM384PQzbQwYHmmU7EMPkKFzxc',
    appId: '1:552418255511:ios:f0a5cdffa19f204d33ffd2',
    messagingSenderId: '552418255511',
    projectId: 'hungry-b1926',
    storageBucket: 'hungry-b1926.appspot.com',
    iosBundleId: 'com.example.hungry',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCxXlyhQHM384PQzbQwYHmmU7EMPkKFzxc',
    appId: '1:552418255511:ios:f0a5cdffa19f204d33ffd2',
    messagingSenderId: '552418255511',
    projectId: 'hungry-b1926',
    storageBucket: 'hungry-b1926.appspot.com',
    iosBundleId: 'com.example.hungry',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAF_40j_h4WH3SA7D3MwRcFZkHK1OO83SA',
    appId: '1:552418255511:web:78fdd1a266d73a4133ffd2',
    messagingSenderId: '552418255511',
    projectId: 'hungry-b1926',
    authDomain: 'hungry-b1926.firebaseapp.com',
    storageBucket: 'hungry-b1926.appspot.com',
  );
}
