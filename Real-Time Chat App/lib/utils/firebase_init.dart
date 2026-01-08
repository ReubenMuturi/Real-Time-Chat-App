import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseInit {
  static Future<void> initialize() async {
    if (kIsWeb) {
      // Web requires options, but for most cases default works
      await Firebase.initializeApp();
    } else {
      await Firebase.initializeApp();
    }
  }
}