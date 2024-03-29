// ignore_for_file: library_private_types_in_public_api

import 'package:find_medicine/pages/home.dart';
import 'package:find_medicine/pages/login.dart';
import 'package:find_medicine/pages/notification_details.dart';
import 'package:find_medicine/pages/notifications.dart';
import 'package:find_medicine/pages/profile.dart';
import 'package:find_medicine/pages/saved_medicines.dart';
import 'package:find_medicine/pages/auth_page.dart';
import 'package:find_medicine/pages/osm_map.dart';
import 'package:find_medicine/pages/settings.dart';
import 'package:find_medicine/pages/splash_screen.dart';
import 'package:find_medicine/pages/wanted_medicines.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/auth_check': (context) => const AuthPage(),
        '/login': (context) => const Login(),
        '/home': (context) => const Home(),
        '/saved': (context) => const SavedMedicines(),
        '/wanted': (context) => const WantedMedicines(),
        '/notifications': (context) => const Notifications(),
        '/details': (context) => const Details(),
        '/map': (context) => const OsmMap(),
        '/settings': (context) => const Settings(),
        '/profile': (context) => const UserProfile(),
      },
    ),
  );
}
