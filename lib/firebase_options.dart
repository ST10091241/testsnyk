// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD4nPI_TVzHxRDCQzdJ-sCi-iHosIvX_YQ',
    appId: '1:281799539865:web:2d4edbbc51e12af3500c08',
    messagingSenderId: '281799539865',
    projectId: 'railways-app-1e7e2',
    authDomain: 'railways-app-1e7e2.firebaseapp.com',
    databaseURL: 'https://railways-app-1e7e2-default-rtdb.firebaseio.com',
    storageBucket: 'railways-app-1e7e2.appspot.com',
    measurementId: 'G-9ZC82RF28P',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAn0deYovlxZ8ayN13_7GNuV99XkS8jSvU',
    appId: '1:281799539865:android:6d9a8d434e124920500c08',
    messagingSenderId: '281799539865',
    projectId: 'railways-app-1e7e2',
    databaseURL: 'https://railways-app-1e7e2-default-rtdb.firebaseio.com',
    storageBucket: 'railways-app-1e7e2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOC3Cek3bvwmxggKUe3brXRmgWMsOgX0M',
    appId: '1:281799539865:ios:b02e5e46156af0ce500c08',
    messagingSenderId: '281799539865',
    projectId: 'railways-app-1e7e2',
    databaseURL: 'https://railways-app-1e7e2-default-rtdb.firebaseio.com',
    storageBucket: 'railways-app-1e7e2.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBOC3Cek3bvwmxggKUe3brXRmgWMsOgX0M',
    appId: '1:281799539865:ios:61eeca358fe8e8cd500c08',
    messagingSenderId: '281799539865',
    projectId: 'railways-app-1e7e2',
    databaseURL: 'https://railways-app-1e7e2-default-rtdb.firebaseio.com',
    storageBucket: 'railways-app-1e7e2.appspot.com',
    iosBundleId: 'com.example.flutterApplication1.RunnerTests',
  );
}
