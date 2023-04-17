// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mailto/mailto.dart';

class NavBar extends StatefulWidget {
  //required username argument
  final String username;

  const NavBar({super.key, required this.username});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
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
                  if (widget.username != 'guest') {
                    Navigator.pushNamed(context, '/saved',
                        arguments: {'username': widget.username});
                  }
                  //navigate to login page if guest
                  if (widget.username == 'guest') {
                    Navigator.pushNamed(context, '/login');
                  }
                },
                child: Column(
                  children: [
                    //icon
                    CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.book,
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

            //insert your medicine
            SizedBox(
              width: 70,
              child: GestureDetector(
                //navigate to wanted medicines page or to login page
                onTap: () {
                  //navigate to wanted medicines page with username argument if logged in
                  if (widget.username != 'guest') {
                    Navigator.pushNamed(context, '/wanted',
                        arguments: {'username': widget.username});
                  }
                  //navigate to login page if guest
                  if (widget.username == 'guest') {
                    Navigator.pushNamed(context, '/login');
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