import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haggle/provider/product_provider.dart';
import 'package:haggle/screens/authentication/email_verification_screen.dart';
import 'package:haggle/screens/location_screen.dart';
import 'package:haggle/screens/main_screen.dart';
import 'package:haggle/screens/main_screen_retailer.dart';





class EmailAuthentication {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<DocumentSnapshot> getAdminCredential(
      {email, isLog, password, context}) async {
    DocumentSnapshot _result = await users.doc(email).get();
    if (isLog) {
      //direct login
      emailLogin(email, password, context);
    } else {
      //if register
      if (_result.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An account already exists with this email address'),
          ),
        );
      } else {
        emailRegister(email, password, context); //register as a new user
      }
    }
    return _result;
  }

  emailLogin(email, password, context) async {
    //login with already register email
    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user?.uid != null) {
        Navigator.pushReplacementNamed(context, MainScreen.id);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found for that email.'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password provided for that user.'),
          ),
        );
      }
    }
  }

  emailRegister(email, password, context) async {
    //register as a new user
    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user?.uid != null) {
        return users.doc(userCredential.user?.uid).set({
          'uid': userCredential.user?.uid,
          'mobile': null,
          'email': userCredential.user?.email,
          'name': null,
          'address': null,
          'shop_name': null,
          'seller_type': null,
          'about': null,
          'ratting':[],
        }).then((value) async {
          // send email verification
          await userCredential.user?.sendEmailVerification().then((value) {
            Navigator.pushReplacementNamed(context, EmailVerificationScreen.id);
          });
        }).catchError((onError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add user'),
            ),
          );
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The password provided is too weak.'),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The account already exists for that email.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error Occured'),
        ),
      );
    }
  }
}
