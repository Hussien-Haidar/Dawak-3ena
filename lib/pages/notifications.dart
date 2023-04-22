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
    var response = await http.post(
      url,
      body: {
        //$_POST['username']
        'email': email ?? '',
      },
    );
    //decode the retreived json data
    var result = jsonDecode(response.body);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.grey[800]),
        backgroundColor: Colors.grey[300],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Notification',
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
            Icon(
              Icons.settings,
              color: Colors.grey[800],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text('proceeding...'),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                list[index]['title'],
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                list[index]['importance'] == 'important'
                                    ? '(Important)'
                                    : '',
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/details',
                                arguments: list[index],
                              );
                            },
                            child: Text(
                              list[index]['body'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Date: ' + list[index]['created_at'],
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/details',
                                      arguments: list[index]);
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left: 8),
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: const [
                                      Text("view more"),
                                      Icon(Icons.keyboard_arrow_right_rounded)
                                    ],
                                  ),
                                ),
                              )
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
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return const Text('Something went Wrong');
                } else {
                  return const Text('No notifications');
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
