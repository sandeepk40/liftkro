// ignore_for_file: unnecessary_new

import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haggle/screens/authentication/email_auth_screen.dart';

class PasswordResetScreen extends StatelessWidget {
  static const String id = 'password-reset-screen';
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _emailController = TextEditingController();
    final _formkey = GlobalKey<FormState>();

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/email.png',
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
            ),
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formkey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 75,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Forgot Password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Enter your registered email,\n We will send you a password reset link',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[100]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      cursorColor: Colors.black,
                      textAlign: TextAlign.center,
                      controller: _emailController,
                      decoration: InputDecoration(
                         errorStyle: const TextStyle(color: Colors.white),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        hintText: 'Enter Registered Email',
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 245, 230),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide:
                              const BorderSide(color: Colors.white, width: .4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide:
                              const BorderSide(color: Colors.white, width: .4),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide:
                              const BorderSide(color: Colors.white, width: .4),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide:
                              const BorderSide(color: Colors.white, width: .4),
                        ),
                      ),
                      validator: (value) {
                        final bool isValid =
                            EmailValidator.validate(_emailController.text);
                        if (value == null || value.isEmpty) {
                          return "Enter Email";
                        }
                        if (value.isNotEmpty && isValid == false) {
                          return 'Enter Valid Email';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.orange[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Send',
                style: TextStyle(color: Colors.black),
              ),
            ),
            onPressed: () {
              if (_formkey.currentState!.validate()) {
                FirebaseAuth.instance
                    .sendPasswordResetEmail(email: _emailController.text)
                    .then((value) {
                  Navigator.pushReplacementNamed(context, EmailAuthScreen.id);
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
