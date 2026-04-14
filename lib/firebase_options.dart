// File generated from google-services.json and GoogleService-Info.plist.
// To regenerate, run: flutterfire configure

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) throw UnsupportedError('Web is not supported.');
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAysl-QNq6ZyN-8340xeyzh7Dh09R26pTg',
    appId: '1:436294698593:android:42ef0e1d3dd02c3a0d8c20',
    messagingSenderId: '436294698593',
    projectId: 'sinhalika-866ca',
    storageBucket: 'sinhalika-866ca.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDR22WUcYOPPvI5ZSSF0QDnH97YC4A09Ms',
    appId: '1:436294698593:ios:de729b9b5f7abef20d8c20',
    messagingSenderId: '436294698593',
    projectId: 'sinhalika-866ca',
    storageBucket: 'sinhalika-866ca.firebasestorage.app',
    iosBundleId: 'com.maddumage.sinhalika',
    iosClientId:
        '436294698593-derke8n2u37vb23grp3b0pq10sn6h1kt.apps.googleusercontent.com',
    androidClientId:
        '436294698593-8im7q7dj5lkt66v8l4s7bp8gbcvmtrqk.apps.googleusercontent.com',
  );
}
