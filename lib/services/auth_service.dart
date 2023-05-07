// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, depend_on_referenced_packages, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthService {
  late var result;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //check if user exists or not, is exist the user login, else the user will sign up automatically
  Future checkUserAvailable(var uid, var fullName, var email) async {
    var link =
        'http://hussien300.000webhostapp.com/Dawak%203ena/google_auth.php';
    Uri url = Uri.parse(link);
    var response = await http.post(
      url,
      body: {
        //$_POST['uid'], $_POST['email']
        'uid': uid,
        'full_name': fullName,
        'email': email,
        'push_token':
            await FirebaseMessaging.instance.getToken() ?? 'push token',
      },
    );
    //Decode the returned json in var result
    result = jsonDecode(response.body);
  }

  Future updatePushToken(var email) async {
    var link =
        'http://hussien300.000webhostapp.com/Dawak%203ena/update_push_token.php';
    Uri url = Uri.parse(link);
    await http.post(
      url,
      body: {
        'email': email,
        'push_token':
            await FirebaseMessaging.instance.getToken() ?? 'push token',
      },
    );
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

    await updatePushToken(FirebaseAuth.instance.currentUser?.email);

    //if account is new, display welcome message
    if (!result['exist']) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.welcomeSir),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            backgroundColor: Colors.grey[200],
            shadowColor: Colors.red[300],
            content: Text(AppLocalizations.of(context)!.thanksForSigningUp),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.close),
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

  signInAnonymously() async {
    await FirebaseAuth.instance.signInAnonymously();
  }

  //google sign out
  Future<void> signOutGoogle() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.disconnect();
  }

  Future<void> signOutAnonymously() async {
    await FirebaseAuth.instance.signOut();
  }
}
