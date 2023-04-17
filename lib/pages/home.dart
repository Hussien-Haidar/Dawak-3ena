// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'package:find_medicine/services/auth_service.dart';
import 'package:find_medicine/widgets/medicine_post.dart';
import 'package:find_medicine/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //for onWillPop method
  DateTime? currentBackPressTime;
  //controller of the search bar
  var SearchedMedicine = TextEditingController();
  //username and profile image
  var username = FirebaseAuth.instance.currentUser?.displayName ?? 'guest';
  var profileImage = FirebaseAuth.instance.currentUser?.photoURL;

  //default medicines list
  var medicines = [];

  //method that retrieves the available medicines
  Future getSearchedMedicines() async {
    //if search bar is not empty
    if (SearchedMedicine.text != "") {
      var link =
          'http://hussien300.000webhostapp.com/Dawak%203ena/medicine_posts.php';
      Uri url = Uri.parse(link);
      var response = await http.post(
        url,
        body: {
          //$_POST['name'] which contains the search value
          'name': SearchedMedicine.text,
        },
      );
      //Decode the returned json in var result
      var result = jsonDecode(response.body);

      //if data found
      if (result["success"]) {
        medicines = result['data'];
      }
      //if data not found
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result["message"]),
            backgroundColor: Colors.grey[500],
          ),
        );
      }
    }
    //if search bar is empty
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Enter valid medicine'),
          backgroundColor: Colors.grey[500],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //execute the onWillPop method
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                //menu bar
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //profile Image
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: GestureDetector(
                          onTap: () {
                            showMenu(
                              context: context,
                              position:
                                  const RelativeRect.fromLTRB(0, 60, 100, 0),
                              elevation: 8.0,
                              items: [
                                //username
                                PopupMenuItem(
                                  value: 1,
                                  //username
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //login/logout text
                                      Text(
                                        username,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13,
                                        ),
                                      ),

                                      //person icon
                                      Icon(
                                        Icons.person,
                                        size: 20,
                                        color: Colors.grey[700],
                                      ),
                                    ],
                                  ),
                                ),

                                //login/logout
                                PopupMenuItem(
                                  value: 2,
                                  //login/logout text and icon
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //login/logout text
                                      Text(
                                        username == 'guest'
                                            ? 'Login'
                                            : 'logout',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13,
                                        ),
                                      ),

                                      //logout icon
                                      Icon(
                                        username == 'guest'
                                            ? Icons.login
                                            : Icons.logout,
                                        size: 20,
                                        color: Colors.grey[700],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ).then((value) {
                              //if login/logout value choosen
                              if (value == 2) {
                                if (username == 'guest') {
                                  Navigator.pushNamed(context, '/login');
                                } else {
                                  AuthService().signOutGoogle();
                                }
                              }
                            });
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(profileImage!),
                            radius: 20,
                          ),
                        ),
                      ),

                      //search bar
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          //search textfield and button
                          child: Row(
                            children: [
                              //search textfield
                              Expanded(
                                child: TextField(
                                  controller: SearchedMedicine,
                                  cursorColor:
                                      const Color.fromRGBO(223, 46, 56, 1),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey.shade200,
                                    hintText: "Medicine Name....",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              //search button
                              Container(
                                padding: const EdgeInsets.only(right: 5),
                                child: ElevatedButton(
                                  //wait to retreive the data
                                  onPressed: () async {
                                    await getSearchedMedicines();
                                    setState(() {});
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    elevation: 10,
                                  ),
                                  //search text
                                  child: const Icon(Icons.search),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                //navbar
                NavBar(username: username.toString()),

                const SizedBox(height: 10),

                //posts container
                MedicinePost(medicines: medicines),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //method that exit the system after two consicutive back button press
  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Press back again to exit'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.grey[500],
        ),
      );
      return false;
    }
    SystemNavigator.pop();
    return true;
  }
}
