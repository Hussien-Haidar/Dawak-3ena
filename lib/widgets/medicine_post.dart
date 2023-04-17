// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings, deprecated_member_use, must_be_immutable

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:http/http.dart' as http;

class MedicinePost extends StatefulWidget {
  //required medicines
  List medicines;

  MedicinePost({super.key, required this.medicines});

  @override
  State<MedicinePost> createState() => _MedicinePostState();
}

class _MedicinePostState extends State<MedicinePost> {
  //email and username
  var email = FirebaseAuth.instance.currentUser?.email;
  var username = FirebaseAuth.instance.currentUser?.displayName ?? 'guest';

  //used to insert new medicine to the saved list in database for the user
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
    var result = jsonDecode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: Colors.grey[500],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
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
              itemCount: widget.medicines.length,
              itemBuilder: (context, index) {
                if (widget.medicines.contains('retreiving data')) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //medicine name + pharmacy name + location and save buttons
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //medicine name + pharmacy name
                          Row(
                            children: [
                              //medicine name
                              Text(
                                widget.medicines[index]['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              //pharmacy name
                              Text(
                                "${"(" + widget.medicines[index]['pharmacy_name']})",
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
                                onTap: () {
                                  //execute saveMedicine method if logged in
                                  if (username != 'guest') {
                                    saveMedicine(
                                        widget.medicines[index]['name'],
                                        widget.medicines[index]
                                            ['pharmacy_name']);
                                  }
                                  //navigate to login page if guest
                                  if (username == 'guest') {
                                    Navigator.pushNamed(context, '/login');
                                  }
                                },
                                child: Row(
                                  children: [
                                    //icon
                                    Icon(
                                      Icons.book,
                                      color: Colors.grey[500],
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
                                    widget.medicines[index]['phone_number'],
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
    );
  }
}
