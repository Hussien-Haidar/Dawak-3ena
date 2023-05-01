// ignore_for_file: prefer_interpolation_to_compose_strings, deprecated_member_use, use_build_context_synchronously

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
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
                              AppLocalizations.of(context)!.savedMedicines,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                                //location button
                                                GestureDetector(
                                                  onTap: () {
                                                      Navigator.pushNamed(
                                                        context,
                                                        '/map',
                                                        arguments:
                                                            list[index],
                                                      );
                                                    },
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
                                                          color:
                                                              Colors.blue[700],
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
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .alert),
                                                          content: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .removePostAlert),
                                                          actions: [
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Colors
                                                                    .grey[700],
                                                              ),
                                                              child: Text(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .back),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                await saveMedicine(
                                                                  list[index]
                                                                      ['name'],
                                                                  list[index][
                                                                      'pharmacy_name'],
                                                                );
                                                                setState(() {});
                                                              },
                                                              child: Text(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .confirm),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },

                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.bookmark_added,
                                                        color: Colors.red[200],
                                                      ),
                                                      //
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .savedAndDone,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.grey[700],
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
                                            decoration: BoxDecoration(
                                              color: list[index]['status'] ==
                                                      'verified'
                                                  ? const Color.fromARGB(
                                                      255, 0, 172, 6)
                                                  : Colors.grey[200],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                            child: Tooltip(
                                              message: list[index]['status'] ==
                                                      'verified'
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .contact
                                                  : AppLocalizations.of(
                                                          context)!
                                                      .notAvailablePostHint,
                                              child: GestureDetector(
                                                //direct to whatsapp specifically to the retreived number
                                                onTap: () async {
                                                  if (list[index]['status'] ==
                                                      'verified') {
                                                    var link = WhatsAppUnilink(
                                                      phoneNumber: "+961" +
                                                          list[index]
                                                              ['phone_number'],
                                                    );
                                                    await launch('$link');
                                                  }
                                                },
                                                child: SvgPicture.asset(
                                                  "assets/icons/whatsapp.svg",
                                                  height: 26,
                                                  color: list[index]
                                                              ['status'] ==
                                                          'verified'
                                                      ? Colors.grey[100]
                                                      : Colors.red[700],
                                                ),
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
                                  AppLocalizations.of(context)!
                                      .noSavedMedicines,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
