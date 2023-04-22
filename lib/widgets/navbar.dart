// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'package:find_medicine/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mailto/mailto.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  var username = FirebaseAuth.instance.currentUser?.displayName ?? 'guest';

  //used to direct the user to the email app to contact with the team
  contactUs() async {
    //destination link
    final mailtoLink = Mailto(
      to: ['72030603@students.liu.edu.lb'],
    );
    //launch the link
    await launch('$mailtoLink');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //saved
            SizedBox(
              width: 70,
              child: GestureDetector(
                //navigate to saved medicines page or login page
                onTap: () {
                  //navigate to saved medicines page with username argument if logged in
                  if (username != 'guest') {
                    Navigator.pushNamed(context, '/saved',
                        arguments: {'username': username});
                  }
                  //navigate to login page if guest
                  if (username == 'guest') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Alert'),
                          content:
                              const Text('you must be signed in, do you want?'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey[700],
                              ),
                              child: const Text('Back'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                AuthService().signOutAnonymously();
                              },
                              child: const Text('Confirm'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Column(
                  children: [
                    //icon
                    CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.bookmark_added,
                        color: Colors.red[200],
                      ),
                    ),

                    const SizedBox(height: 5),

                    //saved
                    const Text(
                      'SAVED',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //wanted
            SizedBox(
              width: 70,
              child: GestureDetector(
                //navigate to wanted medicines page or to login page
                onTap: () {
                  //navigate to wanted medicines page with username argument if logged in
                  if (username != 'guest') {
                    Navigator.pushNamed(context, '/wanted',
                        arguments: {'username': username});
                  }
                  //navigate to login page if guest
                  if (username == 'guest') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Alert'),
                          content:
                              const Text('you must be signed in, do you want?'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey[700],
                              ),
                              child: const Text('Back'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                AuthService().signOutAnonymously();
                              },
                              child: const Text('Confirm'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Column(
                  children: [
                    //icon
                    CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.add_alert_rounded,
                        color: Colors.orange[200],
                      ),
                    ),

                    const SizedBox(height: 5),

                    //wanted
                    const Text(
                      'WANTED',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //contact us
            SizedBox(
              width: 70,
              child: GestureDetector(
                //execute contactUs method
                onTap: contactUs,
                child: Column(
                  children: [
                    //icon
                    CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.send,
                        color: Colors.green[200],
                      ),
                    ),

                    const SizedBox(height: 5),

                    //CONTACT US
                    const Text(
                      'CONTACT US',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //more
            SizedBox(
              width: 70,
              child: Column(
                children: [
                  //icon
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Icon(
                      Icons.more_horiz,
                      color: Colors.lightBlue[200],
                    ),
                  ),

                  const SizedBox(height: 5),

                  //more
                  const Text(
                    'MORE',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
