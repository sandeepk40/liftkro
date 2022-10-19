

import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haggle/screens/authentication/otp_screen.dart';
import 'package:haggle/screens/location_screen.dart';
import 'package:haggle/screens/main_screen.dart';

class PhoneAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser; //changed
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(context, uid) async {
    // Call the user's CollectionReference to add a new user

    final QuerySnapshot result = await users.where('uid', isEqualTo: uid).get();

    List<DocumentSnapshot> document = result.docs; // List of user Data

    if (document.isNotEmpty) {
      //means user data exists
      Navigator.pushReplacementNamed(context, MainScreen.id);
    } else {
      return users.doc(user!.uid).set({
        'uid': user!.uid, // User id
        'mobile': user!.phoneNumber, //User Phone Number
        'email': user!.email,
        'address': null,
        'name': null,
        'shop_name':null,       
        'seller_type':null,  
        'about':null,
      },).then((value) {
        Navigator.pushReplacementNamed(context, MainScreen.id);
      }).catchError((error) => print("Failed to add user: $error"));
    }
  }

  Future<void> verifyPhoneNumber(BuildContext context, number) async {
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }
      print('The error is ${e.code}');
    };
    final PhoneCodeSent codeSent = (String verId, int? resendToken) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(
            number: number,
            verId: verId,
          ),
        ),
      );
    };

    try {
    await auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {
          print(verificationId);
        },
      );
    } catch (e) {
      print(
        'Error ${e.toString()}',
      );
    }
  }
}
