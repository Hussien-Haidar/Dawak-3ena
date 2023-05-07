// ignore_for_file: use_build_context_synchronously

import 'package:find_medicine/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var username = FirebaseAuth.instance.currentUser?.displayName ?? 'Error';
  var email = FirebaseAuth.instance.currentUser?.email ?? 'error';
  var profileImage = FirebaseAuth.instance.currentUser?.photoURL ?? '';

  Future deleteAccount(var email) async {
    var link =
        'http://hussien300.000webhostapp.com/Dawak%203ena/delete_account.php';
    Uri url = Uri.parse(link);
    await http.post(
      url,
      body: {
        'email': email,
      },
    );
  }

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey[400],
              ),
              child: Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(profileImage),
                      backgroundColor: Colors.grey[200],
                      radius: 80,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      username,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      email,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.account,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 7),
                  GestureDetector(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .permanentlyDeleteAccount,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            backgroundColor: Colors.grey[200],
                            shadowColor: Colors.red[300],
                            content: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.of(context)!
                                      .permanentlyDeleteAccountAlert),
                                ],
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () async {
                                  await FirebaseAuth.instance.currentUser!
                                      .delete();
                                  await deleteAccount(email);
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/auth_check',
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[700],
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.delete_forever, size: 30),
                                    Text(AppLocalizations.of(context)!
                                        .deleteAccount),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[400],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(AppLocalizations.of(context)!.back),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_forever,
                          color: Colors.red[500],
                        ),
                        const SizedBox(width: 3),
                        Text(
                          AppLocalizations.of(context)!.deleteAccount,
                          style: TextStyle(
                            color: Colors.red[500],
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  AuthService().signOutGoogle();
                  Navigator.pushReplacementNamed(context, '/auth_check');
                },
                child: Text(
                  "SIGN OUT",
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 2.2,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
