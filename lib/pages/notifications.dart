// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  var email = FirebaseAuth.instance.currentUser?.email;

  //used to retreive the notifications that sent by the administration
  Future getNotifications() async {
    var link =
        'http://hussien300.000webhostapp.com/Dawak%203ena/notifications.php';
    Uri url = Uri.parse(link);
    var response = await http.post(url, body: {
      //$_POST['username']
      'email': email,
    });
    //decode the retreived json data
    var result = jsonDecode(response.body);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: FutureBuilder(
                    future: getNotifications(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Text('proceding...'),
                        );
                      } else if (snapshot.hasData) {
                        //fill data with map
                        Map map = snapshot.data;
                        //fill list with the data argument from the map
                        List list = List.from(map['data']);
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        list[index]['title'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        list[index]['body'],
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    Text(
                                      'Date: ' + list[index]['created_at'],
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(width: 25),
                                    Text(
                                      list[index]['importance'] == 'important'
                                          ? 'Important'
                                          : '',
                                      style: const TextStyle(
                                        backgroundColor: Colors.red,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Divider(
                                  thickness: 1.5,
                                  color: Colors.grey[200],
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        return const Text('No notifications');
                      }
                    },
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
