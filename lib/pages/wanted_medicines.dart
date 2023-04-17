// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class WantedMedicines extends StatefulWidget {
  const WantedMedicines({super.key});

  @override
  State<WantedMedicines> createState() => _WantedMedicinesState();
}

class _WantedMedicinesState extends State<WantedMedicines> {
  //medicine textfield controller
  var medicine = TextEditingController();
  //username
  var email = FirebaseAuth.instance.currentUser?.email;

  //used to retreive the wanted medicines that submitted by the user
  Future getWantedMedicines() async {
    var link =
        'http://hussien300.000webhostapp.com/Dawak%203ena/wanted_medicines.php';
    Uri url = Uri.parse(link);
    var response = await http.post(url, body: {
      //$_POST['username']
      'email': email,
    });
    //decode the retreived json data
    var result = jsonDecode(response.body);
    return result;
  }

  //used to add a wanted medicine
  addMedicine() async {
    //if medicine textfield is not empty
    if (medicine.text.isNotEmpty) {
      var url = Uri.parse(
          'http://hussien300.000webhostapp.com/Dawak%203ena/add_wanted_medicine.php');
      var response = await http.post(url, body: {
        //$_POST['medicine'], //$_POST['username']
        'medicine': medicine.text,
        'email': email,
      });
      //decode the retreived json data
      var result = jsonDecode(response.body);
      //if connected successfully
      if (response.statusCode == 200) {
        //if medicine doesn't exist
        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.grey[500],
            ),
          );
          medicine.text = "";
        }
        //if medicine exist
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.grey[500],
            ),
          );
          medicine.text = "";
        }
      }
      //if not connected
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Failed to add medicine"),
            backgroundColor: Colors.grey[500],
          ),
        );
      }
    }
    //if medicine textfield is empty
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please Enter medicine name"),
          backgroundColor: Colors.grey[500],
        ),
      );
    }
  }

  //used to delete a specific wanted medicine
  deleteMedicine(String medicine) async {
    var url = Uri.parse(
        'http://hussien300.000webhostapp.com/Dawak%203ena/delete_wanted_medicine.php');
    await http.post(url, body: {
      //$_POST['medicine'], //$_POST['email']
      'medicine': medicine,
      'email': email,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            //hint text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                'Hint: Enter the medicine you are searching for and which is not available in the stock, when the medicine is available you will get notified.',
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
            ),

            //add medicine + submit button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  //medicine textfield
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                      ),
                      child: TextField(
                        controller: medicine,
                        cursorColor: const Color.fromRGBO(223, 46, 56, 1),
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: "Add Medicine",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  //submit button
                  SizedBox(
                    height: 57,
                    child: ElevatedButton(
                      //execute the addMedicine method
                      onPressed: () async {
                        await addMedicine();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        elevation: 10,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                      //add
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //wanted medicines
            FutureBuilder(
              //future build using the data of the getWantedMedicines method
              future: getWantedMedicines(),
              builder: (context, snapshot) {
                //if data is being retrieved
                if (snapshot.connectionState == ConnectionState.waiting) {
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
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              //medicine name + delete button
                              child: Row(
                                children: [
                                  //Medicine name
                                  Text(
                                    list[index]['name'],
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  //delete button
                                  GestureDetector(
                                    //execute deleteMedicine method
                                    onTap: () {
                                      setState(() {});
                                      deleteMedicine(list[index]['name']);
                                    },
                                    child: SvgPicture.asset(
                                      'assets/icons/remove.svg',
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                //if data not found
                else {
                  return const Text('Add your first request');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
