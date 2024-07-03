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
    apiKey: 'AIzaSyDc9ertPqYmc8N4_-RJCfS7rtJfaJXftww',
    appId: '1:632144963019:web:75756dd1e11d392932424e',
    messagingSenderId: '632144963019',
    projectId: 'whatsapp-clone-eabd6',
    authDomain: 'whatsapp-clone-eabd6.firebaseapp.com',
    storageBucket: 'whatsapp-clone-eabd6.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDn2AAcLv8V2eW1N7L1JT9k1ysNong9YOg',
    appId: '1:632144963019:android:24c97ebe8fa2787732424e',
    messagingSenderId: '632144963019',
    projectId: 'whatsapp-clone-eabd6',
    storageBucket: 'whatsapp-clone-eabd6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA-lbstw6-XDoCaO-jGLs2dJ8aJD1P2PTE',
    appId: '1:632144963019:ios:b4a83dbd0f1a4bd132424e',
    messagingSenderId: '632144963019',
    projectId: 'whatsapp-clone-eabd6',
    storageBucket: 'whatsapp-clone-eabd6.appspot.com',
    iosBundleId: 'com.example.whatsappClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA-lbstw6-XDoCaO-jGLs2dJ8aJD1P2PTE',
    appId: '1:632144963019:ios:b4a83dbd0f1a4bd132424e',
    messagingSenderId: '632144963019',
    projectId: 'whatsapp-clone-eabd6',
    storageBucket: 'whatsapp-clone-eabd6.appspot.com',
    iosBundleId: 'com.example.whatsappClone',
  );
}
