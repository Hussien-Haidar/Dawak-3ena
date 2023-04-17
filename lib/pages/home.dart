// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:find_medicine/services/auth_service.dart';
import 'package:find_medicine/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

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

  //default medicines list
  var savedMedicines = [];

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
          'email': FirebaseAuth.instance.currentUser?.email,
        },
      );
      //Decode the returned json in var result
      var result = jsonDecode(response.body);

      //if data found
      if (result["success"]) {
        medicines = result['data'];
        savedMedicines = result['saved_medicines'];
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

  Future saveMedicine(var medicine, var pharmacy) async {
    var link =
        'http://hussien300.000webhostapp.com/Dawak%203ena/save_medicine.php';
    Uri url = Uri.parse(link);
    var response = await http.post(url, body: {
      //$_POST['username'], $_POST['medicine'], $_POST['pharmacy_name']
      'email': FirebaseAuth.instance.currentUser?.email,
      'medicine': medicine,
      'pharmacy': pharmacy,
    });
    //decode the retreived json data
    var result = jsonDecode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: Colors.grey[500],
      ),
    );
    if (result["action"] == "saved") {
      savedMedicines.add(int.parse(result['data']));
    }
    if (result["action"] == "removed") {
      savedMedicines.remove(int.parse(result['data']));
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        //sort button
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Medicines
                              Text(
                                "Medicines",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.grey[800],
                                ),
                              ),

                              //sort button
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                    border: Border.all(
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                  //sort by
                                  child: Text(
                                    "Filter",
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //post
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: medicines.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  //medicine name + pharmacy name + location and save buttons
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //medicine name + pharmacy name
                                      Row(
                                        children: [
                                          //medicine name
                                          Text(
                                            medicines[index]['name'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          //pharmacy name
                                          Text(
                                            "${"(" + medicines[index]['pharmacy_name']})",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 5),

                                      //todo: location button + save button
                                      Row(
                                        children: [
                                          //todo: location button
                                          GestureDetector(
                                            onTap: () {},
                                            child: Row(
                                              children: [
                                                //icon
                                                Icon(
                                                  Icons.location_on,
                                                  color: Colors.blue[700],
                                                ),

                                                //location name
                                                Text(
                                                  'Bekaa',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          const SizedBox(width: 20),

                                          //todo: save button
                                          GestureDetector(
                                            //execute saveMedicine method or navigate to login page
                                            onTap: () async {
                                              //execute saveMedicine method if logged in
                                              if (username != 'guest') {
                                                await saveMedicine(
                                                    medicines[index]['name'],
                                                    medicines[index]
                                                        ['pharmacy_name']);
                                                await getSearchedMedicines();
                                                setState(() {});
                                              }
                                              //navigate to login page if guest
                                              if (username == 'guest') {
                                                Navigator.pushNamed(
                                                    context, '/login');
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                //icon
                                                Icon(
                                                  Icons.book,
                                                  color:
                                                      savedMedicines.contains(
                                                              medicines[index]
                                                                  ['id'])
                                                          ? Colors.red[200]
                                                          : Colors.grey[500],
                                                ),

                                                //save
                                                Text(
                                                  "Save",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  //whatsapp button
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 8),
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 0, 172, 6),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      child: GestureDetector(
                                        //direct user to whatsapp specifically to the retreived number
                                        onTap: () async {
                                          var link = WhatsAppUnilink(
                                            phoneNumber: "+961" +
                                                medicines[index]
                                                    ['phone_number'],
                                          );
                                          await launch('$link');
                                        },
                                        child: SvgPicture.asset(
                                          "assets/icons/whatsapp.svg",
                                          height: 26,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
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
