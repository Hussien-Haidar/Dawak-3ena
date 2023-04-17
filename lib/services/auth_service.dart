// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, depend_on_referenced_packages, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService {
  late var result;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //check if user exists or not, is exist the user login, else the user will sign up automatically
  Future checkUserAvailable(var uid, var fullName, var email) async {
    var link =
        'http://hussien300.000webhostapp.com/Dawak%203ena/google_auth.php';
    Uri url = Uri.parse(link);
    var pushToken = await FirebaseMessaging.instance.getToken();
    var response = await http.post(
      url,
      body: {
        //$_POST['uid'], $_POST['email']
        'uid': uid,
        'full_name': fullName,
        'email': email,
        'push_token': pushToken,
      },
    );
    //Decode the returned json in var result
    result = jsonDecode(response.body);
  }

  //google sign in
  signInWithGoogle(BuildContext context) async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //begin interactive sign in process
    final GoogleSignInAccount? user = await _googleSignIn.signIn();

    //obtain auth details from request
    final GoogleSignInAuthentication auth = await user!.authentication;

    //create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );

    //finally, sign up
    await FirebaseAuth.instance.signInWithCredential(credential);

    //pop loading circle
    Navigator.pop(context);

    await checkUserAvailable(
      FirebaseAuth.instance.currentUser?.uid,
      FirebaseAuth.instance.currentUser?.displayName,
      FirebaseAuth.instance.currentUser?.email,
    );

    //if account is new, display welcome message
    if (!result['exist']) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Welcome!'),
            content: const Text('Thanks for signing up!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
    //if account is old, do nothing
    else if (result['exist']) {
      return;
    }

    //anything else, signout and print error message
    else {
      signOutGoogle();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Something Went Wrong!'),
            content: const Text('Please try again'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  //google sign out
  Future<void> signOutGoogle() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.disconnect();
  }
}
