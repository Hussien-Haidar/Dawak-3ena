// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var username = FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous';
  var email = FirebaseAuth.instance.currentUser?.email ?? '';
  var profileImage = FirebaseAuth.instance.currentUser?.photoURL ?? '';

  bool _allowZoomButtons = false;
  bool _allowNotifications = true;

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _allowZoomButtons = prefs.getBool('allowZoomButtons') ?? false;
      _allowNotifications = prefs.getBool('allowNotifications') ?? true;
    });
  }

  _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('allowZoomButtons', _allowZoomButtons);
    await prefs.setBool('allowNotifications', _allowNotifications);
  }

  @override
  void initState() {
    super.initState();
    // Load the value of the switch from SharedPreferences
    _loadSettings();
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
          AppLocalizations.of(context)!.settings,
          style: TextStyle(
            color: Colors.grey[800],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(8),
              color: Colors.grey[50],
              child: ListTile(
                title: Text(
                  username,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                leading: CircleAvatar(
                  backgroundImage: profileImage != ''
                      ? Image.network(profileImage).image
                      : const AssetImage('assets/images/guest.png'),
                  backgroundColor: Colors.grey[200],
                ),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  if (email != '') {
                    Navigator.pushNamed(context, '/profile');
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.grey[50],
              elevation: 4,
              margin: const EdgeInsets.fromLTRB(32, 8, 32, 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.language,
                      color: Colors.red[700],
                    ),
                    title: Text(
                      "Change Language",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {},
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey[400],
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.dark_mode,
                      color: Colors.red[700],
                    ),
                    title: Text(
                      "Change Theme",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.notifications,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SwitchListTile(
              activeColor: Colors.red[700],
              contentPadding: const EdgeInsets.all(0),
              value: _allowNotifications,
              title: const Text("Allow Notifications"),
              onChanged: (newValue) {
                setState(() {
                  _allowNotifications = newValue;
                  _saveSettings();
                });
              },
            ),
            Text(
              AppLocalizations.of(context)!.map,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SwitchListTile(
              activeColor: Colors.red[700],
              contentPadding: const EdgeInsets.all(0),
              value: _allowZoomButtons,
              title: const Text("Allow Zoom in/out buttons"),
              onChanged: (newValue) {
                setState(() {
                  _allowZoomButtons = newValue;
                  _saveSettings();
                });
              },
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
