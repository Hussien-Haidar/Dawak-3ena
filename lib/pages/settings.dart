import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var username = FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous';
  var email = FirebaseAuth.instance.currentUser?.email ?? '';
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
                  backgroundImage: NetworkImage(profileImage),
                ),
                trailing: const Icon(Icons.edit),
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
                      Icons.lock_clock_outlined,
                      color: Colors.red[700],
                    ),
                    title: Text(
                      "Change Password",
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
                      Icons.location_on,
                      color: Colors.red[700],
                    ),
                    title: Text(
                      "Change Location",
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
              value: true,
              title: const Text("Allow Notifications"),
              onChanged: (val) {},
            ),
            SwitchListTile(
              activeColor: Colors.red[700],
              contentPadding: const EdgeInsets.all(0),
              value: false,
              title: const Text("Allow Zoom in/out buttons"),
              onChanged: null,
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
