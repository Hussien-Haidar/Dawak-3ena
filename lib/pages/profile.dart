import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var username = FirebaseAuth.instance.currentUser?.displayName ?? 'Error';
  var email = FirebaseAuth.instance.currentUser?.email ?? 'error';
  var profileImage = FirebaseAuth.instance.currentUser?.photoURL ?? '';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.grey[800]),
        backgroundColor: Colors.grey[200],
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: TextStyle(
            color: Colors.grey[800],
          ),
        ),
      ),
      body: Column(
        children: const [
          CircleAvatar(

          ),
        ],
      ),
    );
  }
}
