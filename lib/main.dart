import 'package:find_medicine/pages/home.dart';
import 'package:find_medicine/pages/login.dart';
import 'package:find_medicine/pages/notifications.dart';
import 'package:find_medicine/pages/saved_medicines.dart';
import 'package:find_medicine/pages/auth_page.dart';
import 'package:find_medicine/pages/wanted_medicines.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/auth_check',
      routes: {
        '/auth_check': (context) => const AuthPage(),
        '/login': (context) => const Login(),
        '/home': (context) => const Home(),
        '/saved': (context) => const SavedMedicines(),
        '/wanted': (context) => const WantedMedicines(),
        '/notifications': (context) => const Notifications(),
      },
    ),
  );
}
