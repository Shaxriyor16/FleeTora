import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

class FirebaseOptions {
  final String apiKey;
  final String appId;
  final String messagingSenderId;
  final String projectId;
  final String storageBucket;
  final String? databaseURL;
  final String iosBundleId;

  const FirebaseOptions({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    this.storageBucket = '',
    this.databaseURL,
    this.iosBundleId = '',
  });
}

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.android:
        return android;
      case TargetPlatform.windows:
        return windows;
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDU7FZPieL4FbtDAbfhtQLAWWfs6q3okuU',
    appId: '1:771598336893:android:ca6be6f5f6cf653de50214',
    messagingSenderId: '771598336893',
    projectId: 'fleetora-b71cf',
    storageBucket: 'fleetora-b71cf.firebasestorage.app',
    databaseURL: 'https://fleetora-b71cf-default-rtdb.europe-west1.firebasedatabase.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDU7FZPieL4FbtDAbfhtQLAWWfs6q3okuU',
    appId: '1:771598336893:android:ca6be6f5f6cf653de50214',
    messagingSenderId: '771598336893',
    projectId: 'fleetora-b71cf',
    storageBucket: 'fleetora-b71cf.firebasestorage.app',
    databaseURL: 'https://fleetora-b71cf-default-rtdb.europe-west1.firebasedatabase.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyASRHc4U-lzl_UTu5WWVwYYTJjLud7k_5I',
    appId: '1:771598336893:ios:7c119a13c87bde9fe50214',
    messagingSenderId: '771598336893',
    projectId: 'fleetora-b71cf',
    storageBucket: 'fleetora-b71cf.firebasestorage.app',
    databaseURL: 'https://fleetora-b71cf-default-rtdb.europe-west1.firebasedatabase.app',
    iosBundleId: 'com.FleeTora',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDU7FZPieL4FbtDAbfhtQLAWWfs6q3okuU',
    appId: '1:771598336893:android:ca6be6f5f6cf653de50214',
    messagingSenderId: '771598336893',
    projectId: 'fleetora-b71cf',
    storageBucket: 'fleetora-b71cf.firebasestorage.app',
    databaseURL: 'https://fleetora-b71cf-default-rtdb.europe-west1.firebasedatabase.app',
  );
}
