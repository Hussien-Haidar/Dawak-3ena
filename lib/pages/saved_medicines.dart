// ignore_for_file: prefer_interpolation_to_compose_strings, deprecated_member_use, use_build_context_synchronously

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:http/http.dart' as http;

class SavedMedicines extends StatefulWidget {
  const SavedMedicines({super.key});

  @override
  State<SavedMedicines> createState() => _SavedMedicinesState();
}

class _SavedMedicinesState extends State<SavedMedicines> {
  var email = FirebaseAuth.instance.currentUser?.email;

  //used to insert new saved medicine to database for the user
  saveMedicine(var medicine, var pharmacy) async {
    var link =
        'http://hussien300.000webhostapp.com/Dawak%203ena/save_medicine.php';
    Uri url = Uri.parse(link);
    var response = await http.post(url, body: {
      //$_POST['username'], $_POST['medicine'], $_POST['pharmacy_name']
      'email': email,
      'medicine': medicine,
      'pharmacy': pharmacy,
    });
    //decode the retreived json data
    jsonDecode(response.body);
  }

  //used to retreive the available saved medicines for the user
  Future getSavedMedicines() async {
    var link =
        'http://hussien300.000webhostapp.com/Dawak%203ena/saved_medicines.php';
    Uri url = Uri.parse(link);
    var response = await http.post(url, body: {
      //_POST['username']
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 30),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    //saved medicines text
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
                      child: Row(
                        children: [
                          //saved medicines
                          Text(
                            "Saved Medicines",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //posts
                    FutureBuilder(
                        //future build using the data of getSavedMedicines method
                        future: getSavedMedicines(),
                        builder: (context, snapshot) {
                          //if data is being retreived
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: CircularProgressIndicator(),
                            );
                          }
                          //if data found
                          else if (snapshot.hasData) {
                            //fill data with map
                            Map map = snapshot.data;
                            //fill list with the data argument from the map
                            List list = List.from(map['data']);
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 30, 0, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      //medicine name + pharmacy name + location button
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //medicine name + pharmacy name
                                          Row(
                                            children: [
                                              //medicine name
                                              Text(
                                                list[index]['name'],
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              //pharmacy name
                                              Text(
                                                "${"(" + list[index]['pharmacy_name']})",
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
                                                    Icon(
                                                      Icons.location_on,
                                                      color: Colors.blue[700],
                                                    ),
                                                    //
                                                    Text(
                                                      'Bekaa',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue[700],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(width: 20),

                                              //save button
                                              GestureDetector(
                                                //execute saveMedicine method
                                                onTap: () {
                                                  saveMedicine(
                                                    list[index]['name'],
                                                    list[index]
                                                        ['pharmacy_name'],
                                                  );
                                                  setState(() {});
                                                },

                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.book,
                                                      color: Colors.red[200],
                                                    ),
                                                    //
                                                    Text(
                                                      "Saved",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 8),
                                          decoration: const BoxDecoration(
                                            color:
                                                Color.fromARGB(255, 0, 172, 6),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                          ),
                                          child: GestureDetector(
                                            //direct to whatsapp specifically to the retreived number
                                            onTap: () async {
                                              var link = WhatsAppUnilink(
                                                phoneNumber: "+961" +
                                                    list[index]['phone_number'],
                                              );
                                              await launch('$link');
                                            },
                                            child: SvgPicture.asset(
                                              "assets/icons/whatsapp.svg",
                                              height: 26,
                                              color: Colors.grey[100],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                          //if data not found
                          else if (!snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'No saved medicines',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'Something went wrong',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
